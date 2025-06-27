from django.shortcuts import render, redirect, get_object_or_404
#from .models import Producto, Boleta, detalle_boleta
#from .forms import ProductoForm, RegistroUserForm, CustomAuthenticationForm
#from django.contrib.auth.forms import AuthenticationForm
from django.contrib.auth import authenticate,login, logout
#from django.shortcuts import redirect
from django.contrib import messages
#from django.core.paginator import Paginator, EmptyPage, PageNotAnInteger
from django.contrib.auth.decorators import login_required
#from .compra import Carrito
#from .forms import CustomAuthenticationForm,RegistroUserForm
from .models import Producto, Cliente, Categoria, Pedido, DetallePedido, EstadoPedido, MetodoPago
from django.shortcuts import render, redirect
from .forms import ClienteForm, ProductoForm
from django.contrib.auth.decorators import login_required, user_passes_test
from django.contrib.auth.models import User
from django.contrib.auth import authenticate, login, get_user_model
from django.shortcuts import redirect, get_object_or_404
from .models import Producto
from django.http import JsonResponse
from django.http import HttpResponse
from . import transbank
import datetime as dt
from django.utils import timezone
from django.db.models.functions import Lower
from django.core.mail import send_mail
from django.conf import settings
from django.utils.crypto import get_random_string
from django.urls import reverse

# Diccionario temporal para tokens (en producción usar modelo o caché)
RESET_TOKENS = {}

def inicio (request):
     return render(request, 'index.html')
def quienesomos(request):
    return render(request, 'quienessomos.html')
def iniciosesion(request):
    if request.method == 'GET':
        # Si el usuario es redirigido a login, muestra un mensaje.
        if 'next' in request.GET:
            messages.warning(request, 'Debes iniciar sesión para acceder a esa página.')
        return render(request, 'inicio_sesion.html')
    else:
        email = request.POST.get('username')
        password = request.POST.get('password')

        # Buscar usuario de Django por email
        User = get_user_model()
        try:
            user_obj = User.objects.get(email=email)
            user = authenticate(request, username=user_obj.username, password=password)
        except User.DoesNotExist:
            user = None

        if user is not None:
            login(request, user)
            return redirect('inicio')

        # Si falla, intentar autenticar como cliente
        try:
            cliente = Cliente.objects.get(email=email, contraseña=password)
            request.session['cliente_id'] = cliente.id_cliente
            request.session['cliente_nombre'] = cliente.nombre
            request.session['cliente_apellido'] = cliente.apellido
            return redirect('inicio')
        except Cliente.DoesNotExist:
            return render(request, 'inicio_sesion.html', {
                'error': 'Correo o contraseña incorrectos.'
            })

def registrar(request):
    data = {'form': ClienteForm()}
    if request.method == "POST":
        formulario = ClienteForm(request.POST)
        if formulario.is_valid():
            formulario.save()       
            return redirect('iniciosesion') 
        else:
            data["form"] = formulario
    return render(request, 'registrate.html', data)

def carrito(request):
    carrito = request.session.get('carrito', {})
    if isinstance(carrito, list):
        carrito = {str(pid): 1 for pid in carrito}
        request.session['carrito'] = carrito

    productos = Producto.objects.filter(id_producto__in=carrito.keys())
    productos_info = []
    total = 0
    total_unidades_carrito = sum(carrito.values())  # 👈 suma de unidades

    for producto in productos:
        cantidad = carrito.get(str(producto.id_producto), 1)
        subtotal = producto.precio * cantidad
        total += subtotal
        productos_info.append({
            'producto': producto,
            'cantidad': cantidad,
            'subtotal': subtotal,
        })

    return render(request, 'carrito.html', {
        'productos_info': productos_info,
        'total': total,
        'total_unidades_carrito': total_unidades_carrito  
    })

from django.http import JsonResponse
from django.shortcuts import redirect

def agregar_al_carrito(request, producto_id):
    exito = False
    if request.method == 'POST':
        carrito = request.session.get('carrito', {})
        producto_id = str(producto_id)
        if producto_id in carrito:
            carrito[producto_id] += 1
        else:
            carrito[producto_id] = 1
        request.session['carrito'] = carrito
        exito = True

    if request.headers.get('x-requested-with') == 'XMLHttpRequest':
        total = sum(carrito.values())
        return JsonResponse({'exito': exito, 'total': total})
    else:
        return redirect('tienda')

def incrementar_cantidad(request, producto_id):
    carrito = request.session.get('carrito', {})
    producto_id = str(producto_id)
    if producto_id in carrito:
        carrito[producto_id] += 1
    request.session['carrito'] = carrito
    return redirect('carrito')

def disminuir_cantidad(request, producto_id):
    carrito = request.session.get('carrito', {})
    producto_id = str(producto_id)
    if producto_id in carrito and carrito[producto_id] > 1:
        carrito[producto_id] -= 1
    elif producto_id in carrito:
        del carrito[producto_id]
    request.session['carrito'] = carrito
    return redirect('carrito')

def tiendabecs(request):
    productos = Producto.objects.all()

    #obtener parámetros GET
    q = request.GET.get('q', '')
    orden = request.GET.get('orden', '')

    #filtro de búsqueda
    if q:
        productos = productos.filter(nombre_producto__icontains=q)
    if orden == 'precio_desc':
        productos = productos.order_by('-precio')
    elif orden == 'precio_asc':
        productos = productos.order_by('precio')
    elif orden == 'nombre_asc':
        productos = productos.order_by(Lower('nombre_producto').asc())

    #calculamos la cantidad total de unidades del carrito
    carrito = request.session.get('carrito', {})
    total_unidades_carrito = sum(carrito.values())

    return render(request, 'tienda.html', {
        'productos': productos,
        'total_unidades_carrito': total_unidades_carrito
    })

def salir(request):
    logout(request)
    return redirect('inicio')

@login_required
@user_passes_test(lambda u: u.is_staff)
def administrador(request):
    form = ProductoForm()
    mensaje = ""
    if request.method == "POST":
        form = ProductoForm(request.POST, request.FILES)
        if form.is_valid():
            form.save()
            mensaje = "Producto agregado correctamente."
            form = ProductoForm()  # Limpiar el formulario
    productos = Producto.objects.all()
    categorias = Categoria.objects.all()
    return render(request, 'admin.html', {'form': form, 'mensaje': mensaje, 'productos': productos, 'categorias': categorias})

def eliminar_del_carrito(request, producto_id):
    carrito = request.session.get('carrito', {})
    producto_id = str(producto_id)
    if producto_id in carrito:
        del carrito[producto_id]
        request.session['carrito'] = carrito
    return redirect('carrito')

def vaciar_carrito(request):
    if 'carrito' in request.session:
        del request.session['carrito']
    return redirect('carrito')

def eliminar_producto(request, producto_id):
    if request.method == "POST":
        producto = get_object_or_404(Producto, id_producto=producto_id)
        producto.delete()
    return redirect('admin')

@login_required
@user_passes_test(lambda u: u.is_staff)
def modificar_producto(request, producto_id):
    producto = get_object_or_404(Producto, id_producto=producto_id)
    if request.method == 'POST':
        form = ProductoForm(request.POST, request.FILES, instance=producto)
        if form.is_valid():
            form.save()
            return redirect('admin')
    else:
        form = ProductoForm(instance=producto)
    return render(request, 'formulario_modificar_producto.html', {'form': form, 'producto': producto})

@login_required
@user_passes_test(lambda u: u.is_staff)
def agregar_producto(request):
    categorias = Categoria.objects.all()
    if request.method == 'POST':
        nombre = request.POST.get('nombre_producto')
        descripcion = request.POST.get('descripcion')
        precio = request.POST.get('precio')
        stock = request.POST.get('stock')
        imagen = request.FILES.get('imagen')
        id_categoria = request.POST.get('id_categoria')

        if not (nombre and descripcion and precio and stock and imagen and id_categoria):
            messages.error(request, 'Todos los campos son obligatorios.')
            return render(request, 'admin.html', {'categorias': categorias})

        producto = Producto(
            nombre_producto=nombre,
            descripcion=descripcion,
            precio=precio,
            stock=stock,
            imagen=imagen,
            id_categoria=Categoria.objects.get(id_categoria=id_categoria)
        )
        producto.save()
        messages.success(request, 'Producto agregado correctamente.')
        return redirect('admin')
    else:
        return render(request, 'admin.html', {'categorias': categorias})

def commit_pay(request):
    """
    Procesa el resultado del pago realizado a través de Transbank y muestra el detalle al usuario.
    Vacía el carrito si el pago fue exitoso.
    """
    transaction_detail = {}
    # Buscar el token en POST o en GET
    token_ws = request.POST.get('token_ws') or request.GET.get('token_ws')
    if token_ws:
        response = transbank.transbank_commit(token_ws)
        if response.status_code == 200:
            response = response.json()
            status = response['status']
            response_code = response['response_code']

            if status == 'AUTHORIZED' and response_code == 0:
                # Transacción exitosa
                state = 'ACEPTADO'
                pay_type = 'Tarjeta de Débito' if response['payment_type_code'] == 'VD' else 'Tarjeta de Crédito'
                amount = int(response['amount'])
                amount = f'{amount:,.0f}'.replace(',','.')
                transaction_date = dt.datetime.strptime(response['transaction_date'], '%Y-%m-%dT%H:%M:%S.%fZ')
                transaction_date = '{:%d-%m-%Y %H:%M:%S}'.format(transaction_date)
                transaction_detail = {
                    'card_number': response['card_detail']['card_number'],
                    'transaction_date': transaction_date,
                    'state': state,
                    'pay_type': pay_type,
                    'amount': amount,
                    'authorization_code': response['authorization_code'],
                    'buy_order': response['buy_order'],
                }
                # Vaciar el carrito solo si el pago fue exitoso
                if 'carrito' in request.session:
                    
                    # 1. Obtener el cliente (ajusta según tu lógica de sesión o usuario autenticado)
                    cliente = None
                    if request.session.get('cliente_id'):
                        cliente_id = request.session.get('cliente_id')
                        cliente = Cliente.objects.get(id_cliente=cliente_id)
                    elif request.user.is_authenticated:
                        # Si el cliente está autenticado como usuario de Django, puedes buscarlo por email o crear uno
                        try:
                            cliente = Cliente.objects.get(email=request.user.email)
                        except Cliente.DoesNotExist:
                            # Opcional: Si no existe, puedes crear un cliente a partir del usuario de Django
                            pass # O manejar de otra forma si el cliente no está en tu modelo Cliente

                    # Si no se pudo obtener un cliente, manejar el caso (ej. no registrar el pedido o registrar como invitado)
                    if cliente:
                        # 2. Obtener estado y método de pago (asegúrate que existan en tu base de datos)
                        try:
                            estado_pedido = EstadoPedido.objects.get(estado='Pagado')  # Ajusta el nombre del estado
                        except EstadoPedido.DoesNotExist:
                            estado_pedido = EstadoPedido.objects.create(estado='Pagado') # Crea si no existe

                        try:
                            metodo_pago = MetodoPago.objects.get(nombre='Transbank')  # Ajusta el nombre del método de pago
                        except MetodoPago.DoesNotExist:
                            metodo_pago = MetodoPago.objects.create(nombre='Transbank', descripcion='Pago con tarjeta via Transbank') # Crea si no existe

                        # 3. Crear el pedido
                        pedido = Pedido.objects.create(
                            fecha_pedido=timezone.now(),
                            cliente_id_cliente=cliente,
                            id_estado_pedido=estado_pedido,
                            metodo_pago_id_metodo_pago=metodo_pago,
                            transbank_transaction_date=dt.datetime.strptime(response['transaction_date'], '%Y-%m-%dT%H:%M:%S.%fZ'),
                            transbank_state=state,
                            transbank_pay_type=pay_type,
                            transbank_amount=int(response['amount']),
                            transbank_buy_order=response['buy_order'],
                            # Asegúrate de agregar cualquier otro campo requerido por tu modelo Pedido
                        )

                        # 4. Poblar los detalles del pedido
                        carrito = request.session.get('carrito', {})
                        for producto_id_str, cantidad in carrito.items():
                            try:
                                producto = Producto.objects.get(id_producto=producto_id_str)
                                DetallePedido.objects.create(
                                    pedido_id_pedido=pedido,
                                    id_producto=producto,
                                    cantidad=cantidad,
                                    precio_unitario=producto.precio # Guarda el precio unitario en el momento de la compra
                                )
                            except Producto.DoesNotExist:
                                # Manejar caso donde el producto no existe (ej. log error, saltar)
                                pass
                        
                    del request.session['carrito']

            else:
                # Transacción rechazada o fallida
                state = 'RECHAZADO' if status == 'FAILED' else status
                pay_type = 'Tarjeta de Débito' if response['payment_type_code'] == 'VD' else 'Tarjeta de Crédito'
                amount = int(response['amount'])
                amount = f'{amount:,.0f}'.replace(',', '.')
                transaction_date = dt.datetime.strptime(response['transaction_date'], '%Y-%m-%dT%H:%M:%S.%fZ')
                transaction_date = '{:%d-%m-%Y %H:%M:%S}'.format(transaction_date)
                transaction_detail = {
                    'card_number': response['card_detail']['card_number'],
                    'transaction_date': transaction_date,
                    'state': state,
                    'pay_type': pay_type,
                    'amount': amount,
                    'authorization_code': response['authorization_code'],
                    'buy_order': response['buy_order'],
                }
        else:
            # Error en la respuesta de Transbank
            transaction_detail = {'error': 'Error al procesar el pago.'}
    else:
        # No se recibió el token de pago
        transaction_detail = {'error': 'No se recibió el token de pago.'}
    return render(request, 'commit_pay.html', {'transaction_detail': transaction_detail})

@user_passes_test(lambda u: u.is_staff)
def lista_pedidos(request):
    # Cambiar estado a 'Terminado' si se recibe un POST con el id del pedido
    if request.method == 'POST' and 'terminar_pedido_id' in request.POST:
        pedido_id = request.POST.get('terminar_pedido_id')
        pedido = Pedido.objects.get(id_pedido=pedido_id)
        estado_terminado, _ = EstadoPedido.objects.get_or_create(estado='Terminado')
        pedido.id_estado_pedido = estado_terminado
        pedido.save()
    # Pedidos no terminados
    pedidos = Pedido.objects.exclude(id_estado_pedido__estado='Terminado').order_by('-fecha_pedido')
    # Pedidos terminados
    pedidos_terminados = Pedido.objects.filter(id_estado_pedido__estado='Terminado').order_by('-fecha_pedido')
    dia = request.GET.get('dia')
    mes = request.GET.get('mes')
    anio = request.GET.get('anio')
    if dia:
        pedidos = pedidos.filter(fecha_pedido__day=dia)
    if mes:
        pedidos = pedidos.filter(fecha_pedido__month=mes)
    if anio:
        pedidos = pedidos.filter(fecha_pedido__year=anio)
    return render(request, 'lista_pedidos.html', {'pedidos': pedidos, 'pedidos_terminados': pedidos_terminados})

def solicitar_reseteo_cliente(request):
    if request.method == 'POST':
        email = request.POST.get('email')
        try:
            cliente = Cliente.objects.get(email=email)
            token = get_random_string(32)
            RESET_TOKENS[token] = cliente.id_cliente
            reset_url = request.build_absolute_uri(reverse('resetear_contraseña_cliente', args=[token]))
            send_mail(
                'Recupera tu contraseña',
                f'Para restablecer tu contraseña haz clic en el siguiente enlace: {reset_url}',
                settings.EMAIL_HOST_USER,
                [email],
                fail_silently=False,
            )
            return render(request, 'solicitar_reseteo_exito.html', {'email': email})
        except Cliente.DoesNotExist:
            return render(request, 'solicitar_reseteo_cliente.html', {'error': 'No existe un cliente con ese correo.'})
    return render(request, 'solicitar_reseteo_cliente.html')

def resetear_contraseña_cliente(request, token):
    cliente_id = RESET_TOKENS.get(token)
    if not cliente_id:
        return render(request, 'resetear_contraseña_cliente.html', {'error': 'Token inválido o expirado.'})
    if request.method == 'POST':
        password1 = request.POST.get('password1')
        password2 = request.POST.get('password2')
        if password1 != password2:
            return render(request, 'resetear_contraseña_cliente.html', {'error': 'Las contraseñas no coinciden.', 'token': token})
        cliente = Cliente.objects.get(id_cliente=cliente_id)
        cliente.contraseña = password1
        cliente.save()
        del RESET_TOKENS[token]
        return render(request, 'resetear_contraseña_exito.html')
    return render(request, 'resetear_contraseña_cliente.html', {'token': token})

          
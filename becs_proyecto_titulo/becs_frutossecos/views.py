from django.shortcuts import render, redirect, get_object_or_404
#from .models import Producto, Boleta, detalle_boleta
#from .forms import ProductoForm, RegistroUserForm, CustomAuthenticationForm
#from django.contrib.auth.forms import AuthenticationForm
from django.contrib.auth import authenticate,login, logout
#from django.shortcuts import redirect
#from django.contrib import messages
#from django.core.paginator import Paginator, EmptyPage, PageNotAnInteger
from django.contrib.auth.decorators import login_required
#from .compra import Carrito
#from .forms import CustomAuthenticationForm,RegistroUserForm
from .models import Producto, Cliente
from django.shortcuts import render, redirect
from .forms import ClienteForm
from django.contrib.auth.decorators import login_required, user_passes_test
from django.contrib.auth.models import User
from django.contrib.auth import authenticate, login, get_user_model

def inicio (request):
     return render(request, 'index.html')

def iniciosesion(request):
    if request.method == 'GET':
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
    return render(request, 'carrito.html')

def tiendabecs (request):
    productos = Producto.objects.all()
    return render(request, 'tienda.html', {'productos': productos})

def salir(request):
    logout(request)
    return redirect('inicio')

@login_required
@user_passes_test(lambda u: u.is_staff)
def administrador(request):
    return render(request,'admin.html')
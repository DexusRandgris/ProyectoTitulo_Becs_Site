import requests
from django.shortcuts import render, redirect
import uuid
from django.contrib.auth.decorators import login_required

# MÉTODO QUE CREA LA CABECERA SOLICITADA POR TRANSBANK EN UN REQUEST (SOLICITUD)
def header_request_transbank():
    print('header_request_transbank')
    headers = { # DEFINICIÓN TIPO DE AUTORIZACIÓN Y AUTENTICACIÓN
                "Authorization": "Token",
                # LLAVE QUE DEBE SER MODIFICADA PORQUE ES SOLO DEL AMBIENTE DE INTEGRACIÓN DE TRANSBANK (PRUEBAS)
                "Tbk-Api-Key-Id": "597055555532",
                # LLAVE QUE DEBE SER MODIFICADA PORQUE DEL AMBIENTE DE INTEGRACIÓN DE TRANSBANK (PRUEBAS)
                "Tbk-Api-Key-Secret": "579B532A7440BB0C9079DED94D31EA1615BACEB56610332264630D42D0A36B1C",
                # DEFINICIÓN DEL TIPO DE INFORMACIÓN ENVIADA
                "Content-Type": "application/json",
                # DEFINICIÓN DE RECURSOS COMPARTIDOS ENTRE DISTINTOS SERVIDORES PARA CUALQUIER MÁQUINA
                "Access-Control-Allow-Origin": "*",
                'Referrer-Policy': 'origin-when-cross-origin',
                } 
    return headers   

# Función personalizada para validar autenticación
def require_auth(view_func):
    def wrapper(request, *args, **kwargs):
        # Verificar si es usuario de Django autenticado
        if request.user.is_authenticated:
            return view_func(request, *args, **kwargs)
        # Verificar si es cliente autenticado en sesión
        elif request.session.get('cliente_id'):
            return view_func(request, *args, **kwargs)
        else:
            # Redirigir al login si no está autenticado
            return redirect('iniciosesion')
    return wrapper

# DEFINICIÓN DE RUTA API REST, PERMITIENDO SOLO SER LLAMADO POR POST
@require_auth
def transbank_create(request):
    print('transbank_create')
    if request.method == 'POST':
        amount =  request.POST.get('amount')
        if not amount:
            return render(request, 'carrito.html', {'error': 'No se recibió el monto'})
    else:
        amount = 0

    #Generar numero de orden aleatorio
    buy_order = str(uuid.uuid4())[:26]

    data = {
        "buy_order" : buy_order,
        "session_id" : str(request.session.session_key),
        "amount" : int(amount),
        "return_url" : "http://localhost:8000/commit_pay"
    }
    print('data: ', data)
    # DEFINICIÓN DE URL DE TRANSBANK PARA CREAR UNA TRANSACCIÓN
    url = "https://webpay3gint.transbank.cl/rswebpaytransaction/api/webpay/v1.2/transactions"
    # CABECERA SOLICITADA POR TRANSBANK
    headers = header_request_transbank()
    # INVOCACIÓN POR POST A API REST QUE CREA UNA TRANSACCIÓN EN TRANSBANK
    contexto = {}
    try:
        response = requests.post(url, json = data, headers=headers)
        print('response: ', response.json())
        contexto = response.json()
    except Exception as e:
        print(e)

    # RETORNO DE LA RESPUESTA DE TRANSBANK
    return render(request, 'send-pay.html', {'contexto': contexto})

def transbank_commit(token_ws):
    print('token_ws:', token_ws)
    url = f"https://webpay3gint.transbank.cl/rswebpaytransaction/api/webpay/v1.2/transactions/{token_ws}"

    headers = header_request_transbank()

    response = requests.put(url, headers=headers)

    return response
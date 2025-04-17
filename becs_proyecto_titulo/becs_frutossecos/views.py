from django.shortcuts import render, redirect, get_object_or_404
#from .models import Producto, Boleta, detalle_boleta
#from .forms import ProductoForm, RegistroUserForm, CustomAuthenticationForm
#from django.contrib.auth.forms import AuthenticationForm
#from django.contrib.auth import authenticate,login, logout
#from django.shortcuts import redirect
#from django.contrib import messages
#from django.core.paginator import Paginator, EmptyPage, PageNotAnInteger
from django.contrib.auth.decorators import login_required
#from .compra import Carrito
from .forms import CustomAuthenticationForm,RegistroUserForm

def inicio (request):
     return render(request, 'index.html')

def iniciosesion (request):
    if request.method == 'GET':
        return render(request, 'inicio_sesion.html',{
            'form': CustomAuthenticationForm()
        })
    else:
        user = authenticate(
            request,
            username = request.POST['username'],
            password = request.POST['password']
        )
    if user is None:
        return render(request,'inicio_sesion.html',{
            'form':CustomAuthenticationForm(),
            'error':'Datos incorrectos'
        })
    else:
        login(request,user)
        return redirect('inicio')


def registrar(request):
    data={                         
        'form': RegistroUserForm()
    }
    if request.method=="POST":
        formulario = RegistroUserForm(data=request.POST)
        if formulario.is_valid():
            formulario.save()       
            user = authenticate(username=formulario.cleaned_data["username"], 
                    password=formulario.cleaned_data["password1"])
            login(request,user)
            return redirect('inicio') 
        data["form"]=formulario           
    return render(request, 'registrate.html',data)
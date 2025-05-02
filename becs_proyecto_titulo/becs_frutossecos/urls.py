
from django.contrib import admin
from django.urls import path, include
from . import views

urlpatterns = [

    path('login/',      views.iniciosesion,  name='iniciosesion'),
    # → http://127.0.0.1:8000/registrate/
    path('registrate/', views.registrar,     name='registrate'),
    # (opcional) si quieres seguir con /index/
    path('',      views.inicio,        name='inicio'),
    path('carrito/',  views.carrito,      name='carrito'),
    path('tienda/', views.tiendabecs, name='tienda'),
    path('salir/', views.salir, name='logout'),
]

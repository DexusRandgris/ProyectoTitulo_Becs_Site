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
    path('agregar-al-carrito/<int:producto_id>/', views.agregar_al_carrito, name='agregar_al_carrito'),
    path('tienda/', views.tiendabecs, name='tienda'),
    path('salir/', views.salir, name='salir'),
    path('administrador/', views.administrador, name='admin'),
    path('admin/', admin.site.urls),
    path('eliminar-del-carrito/<int:producto_id>/', views.eliminar_del_carrito, name='eliminar_del_carrito'),
    path('incrementar-cantidad/<int:producto_id>/', views.incrementar_cantidad, name='incrementar_cantidad'),
    path('disminuir-cantidad/<int:producto_id>/', views.disminuir_cantidad, name='disminuir_cantidad'),
]

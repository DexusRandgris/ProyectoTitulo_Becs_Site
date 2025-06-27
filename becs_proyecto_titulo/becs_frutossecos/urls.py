from django.contrib import admin
from django.urls import path, include
from . import views
from . import transbank
from django.contrib.auth import views as auth_views
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
    path('vaciar-carrito/', views.vaciar_carrito, name='vaciar_carrito'),
    path('eliminar-producto/<int:producto_id>/', views.eliminar_producto, name='eliminar_producto'),
    path('modificar-producto/<int:producto_id>/', views.modificar_producto, name='modificar_producto'),
    path('agregar_producto/', views.agregar_producto, name='agregar_producto'),
    path('transbank', transbank.transbank_create, name='transbank'),
    path('commit_pay', views.commit_pay, name='commit_pay'),
    path('administrador/pedidos/', views.lista_pedidos, name='lista_pedidos'),
    path('quienessomos/', views.quienesomos, name='quienesomos'),
    path('solicitar-reseteo-cliente/', views.solicitar_reseteo_cliente, name='solicitar_reseteo_cliente'),
    path('resetear-contraseña-cliente/<str:token>/', views.resetear_contraseña_cliente, name='resetear_contraseña_cliente'),

]


from django.contrib import admin
from django.urls import path, include
from . import views

urlpatterns = [
    path('admin/', admin.site.urls),
    path('login/', views.iniciosesion, name='iniciosesion'),  # Cambié 'login_view' a 'iniciosesion'
    path('index/', views.inicio, name='inicio'),
    path('registrate', views.registrar, name='registrate'),
]
from django.contrib import admin
from becs_frutossecos.models import Carrito, Categoria, Cliente
from becs_frutossecos.models import DetalleCarrito, DetallePedido, EstadoPedido
from becs_frutossecos.models import Inventario, MetodoPago, Pedido
from becs_frutossecos.models import Producto, Reporte, Rol, ValoracionCliente

# Register your models here.
admin.site.register(Carrito)
admin.site.register(Categoria)
admin.site.register(Cliente)
admin.site.register(DetalleCarrito)
admin.site.register(DetallePedido)
admin.site.register(EstadoPedido)
admin.site.register(Inventario)
admin.site.register(MetodoPago)
admin.site.register(Pedido)
admin.site.register(Producto)
admin.site.register(Reporte)
admin.site.register(Rol)
admin.site.register(ValoracionCliente)
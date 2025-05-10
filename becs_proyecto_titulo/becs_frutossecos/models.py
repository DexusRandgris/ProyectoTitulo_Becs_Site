from django.db import models
#from django.contrib.auth.models import AbstractUser

class Carrito(models.Model):
    id_carrito = models.AutoField(primary_key=True)
    cliente_id_cliente = models.IntegerField()
    fecha_carrito = models.DateTimeField()

    class Meta:
        managed = False
        db_table = 'carrito'


class Categoria(models.Model):
    id_categoria = models.AutoField(primary_key=True)
    nombre = models.CharField(max_length=100)
    descripcion = models.CharField(max_length=100)

    class Meta:
        managed = False
        db_table = 'categoria'

class Cliente(models.Model):
    id_cliente = models.AutoField(primary_key=True)
    nombre = models.CharField(max_length=100)
    apellido = models.CharField(max_length=100)
    email = models.CharField(max_length=100)
    contraseña = models.CharField(max_length=100)
    telefono = models.IntegerField()
    direccion = models.CharField(max_length=100)
    rol = models.ForeignKey('Rol', models.DO_NOTHING)

    class Meta:
        managed = False
        db_table = 'cliente'


class DetalleCarrito(models.Model):
    id_detalle_carrito = models.AutoField(primary_key=True)
    cantidad = models.IntegerField()
    id_carrito = models.ForeignKey(Carrito, models.DO_NOTHING, db_column='id_carrito')
    id_producto = models.ForeignKey('Producto', models.DO_NOTHING, db_column='id_producto')

    class Meta:
        managed = False
        db_table = 'detalle_carrito'


class DetallePedido(models.Model):
    id_detalle_pedido = models.AutoField(primary_key=True)
    cantidad = models.IntegerField()
    precio_unitario = models.IntegerField()
    pedido_id_pedido = models.ForeignKey('Pedido', models.DO_NOTHING, db_column='pedido_id_pedido')
    id_producto = models.ForeignKey('Producto', models.DO_NOTHING, db_column='id_producto')

    class Meta:
        managed = False
        db_table = 'detalle_pedido'



class EstadoPedido(models.Model):
    id_estado_pedido = models.AutoField(primary_key=True)
    estado = models.CharField(max_length=100)

    class Meta:
        managed = False
        db_table = 'estado_pedido'


class Inventario(models.Model):
    id_mov = models.AutoField(primary_key=True)
    cantidad = models.IntegerField()
    fecha = models.DateTimeField()
    motivo = models.CharField(max_length=100)
    id_producto = models.ForeignKey('Producto', models.DO_NOTHING, db_column='id_producto')

    class Meta:
        managed = False
        db_table = 'inventario'


class MetodoPago(models.Model):
    id_metodo_pago = models.AutoField(primary_key=True)
    nombre = models.CharField(max_length=100)
    descripcion = models.CharField(max_length=100)

    class Meta:
        managed = False
        db_table = 'metodo_pago'


class Pedido(models.Model):
    id_pedido = models.AutoField(primary_key=True)
    fecha_pedido = models.DateTimeField()
    cliente_id_cliente = models.ForeignKey(Cliente, models.DO_NOTHING, db_column='cliente_id_cliente')
    id_estado_pedido = models.ForeignKey(EstadoPedido, models.DO_NOTHING, db_column='id_estado_pedido')
    metodo_pago_id_metodo_pago = models.ForeignKey(MetodoPago, models.DO_NOTHING, db_column='metodo_pago_id_metodo_pago')
    reporte_id_reporte = models.ForeignKey('Reporte', models.DO_NOTHING, db_column='reporte_id_reporte', blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'pedido'


class Producto(models.Model):
    id_producto = models.AutoField(primary_key=True)
    nombre_producto = models.CharField(max_length=30)
    descripcion = models.CharField(max_length=100)
    precio = models.IntegerField()
    stock = models.IntegerField()
    imagen = models.BinaryField()
    fecha_creacion = models.DateField()
    id_categoria = models.ForeignKey(Categoria, models.DO_NOTHING, db_column='id_categoria')

    class Meta:
        managed = False
        db_table = 'producto'


class Reporte(models.Model):
    id_reporte = models.AutoField(primary_key=True)
    nombre = models.CharField(max_length=100)
    descripcion = models.CharField(max_length=100)
    pedido_id_pedido = models.OneToOneField(Pedido, models.DO_NOTHING, db_column='pedido_id_pedido', blank=True, null=True)

    class Meta:
        managed = False
        db_table = 'reporte'


class Rol(models.Model):
    id_rol = models.AutoField(primary_key=True)
    nombre = models.CharField(max_length=30)

    class Meta:
        managed = False
        db_table = 'rol'


class ValoracionCliente(models.Model):
    id_valoracion_cliente = models.AutoField(primary_key=True)
    valoracion = models.CharField(max_length=1, blank=True, null=True)
    nombre = models.CharField(max_length=40, blank=True, null=True)
    comentario = models.CharField(max_length=100, blank=True, null=True)
    cliente_id_cliente = models.ForeignKey(Cliente, models.DO_NOTHING, db_column='cliente_id_cliente')
    id_producto = models.ForeignKey(Producto, models.DO_NOTHING, db_column='id_producto')

    class Meta:
        managed = False
        db_table = 'valoracion_cliente'


#class CustomUser(AbstractUser):
#    username = None
#    email = models.EmailField(unique=True)
#
#    USERNAME_FIELD = 'email'
#    REQUIRED_FIELDS = ['first_name', 'last_name', 'password1', 'password2']
#
#    def __str__(self):
#        return self.email
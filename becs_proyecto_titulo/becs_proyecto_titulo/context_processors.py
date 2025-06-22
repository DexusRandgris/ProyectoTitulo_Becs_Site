
def carrito_count(request):
    carrito = request.session.get('carrito', {})
    total_unidades_carrito = sum(carrito.values()) if carrito else 0
    return {
        'total_unidades_carrito': total_unidades_carrito
    }
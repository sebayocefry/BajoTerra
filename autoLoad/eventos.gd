extends Node

# Señales globales para la UI
signal vida_actualizada(vida_actual: int, vida_maxima: int)
signal mana_actualizado(mana_actual: int)
signal arma_equipada_cambiada(icono: Texture2D)
signal consumible_equipado_cambiado(icono: Texture2D)

signal oro_actualizado(nuevo_total: int)

signal solicitar_apertura_tienda(inventario: Array, comerciante_referencia: Comerciante)
signal cerrar_ui_tienda()

signal jugador_muerto()

# Transiciones internas del nivel
signal transicion_habitacion_solicitada(ruta_habitacion: String, coordenada_destino: Vector2)

extends Node

# Señales globales para la UI
signal vida_actualizada(vida_actual: int, vida_maxima: int)
signal mana_actualizado(mana_actual: int)
signal arma_equipada_cambiada(icono: Texture2D)
signal consumible_equipado_cambiado(icono: Texture2D)
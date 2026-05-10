extends Node


var vida_actual : int = 100
var mana_actual : int = 0
var oro_actual : int = 0
var inventario : Array = [] 

# Memoria falsa o espacial: {"res://habitacion_1.tscn": true, "res://habitacion_2.tscn": true}
# guardamos como los datos de la habitacion como en un diccionario asi no se pierden las cosas, esto
#pasa como 1 frame antesd de salire de la habitacion
var habitaciones_limpias : Dictionary = {}

func guardar_estado_jugador(player: Player):
    vida_actual = player.vida
    mana_actual = player.mana
    oro_actual = player.oro
    inventario = player.listaObjetos.duplicate() 
func cargar_estado_jugador(player: Player):
    player.vida = vida_actual
    player.mana = mana_actual
    player.oro = oro_actual
    player.listaObjetos = inventario.duplicate()
    
    
    Eventos.vida_actualizada.emit(player.vida, 100) 
    Eventos.mana_actualizado.emit(player.mana)
    Eventos.oro_actualizado.emit(player.oro)
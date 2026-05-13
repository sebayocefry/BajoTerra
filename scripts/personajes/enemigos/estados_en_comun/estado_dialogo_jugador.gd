extends Estado
class_name EstadoDialogoJugador

func entrar():
    var player = actor as Player
    if player:

        player.movement.move(player, Vector2.ZERO)
        player.update_animation("idle")
    
    Dialogic.timeline_ended.connect(_al_terminar_dialogo)

func salir():
    Dialogic.timeline_ended.disconnect(_al_terminar_dialogo)

func _al_terminar_dialogo():

    transicion.emit("EstadoActivoJugador")
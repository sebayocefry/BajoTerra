extends Estado

func entrar():
    enemigo.velocity = Vector2.ZERO
    if animacion.current_animation != enemigo.anim_reposo:
        animacion.play(enemigo.anim_reposo)

func actualizar_fisica(_delta: float):
    if enemigo.jugador:
        var distancia = enemigo.global_position.distance_to(enemigo.jugador.global_position)
        
        # Si el jugador se acerca lo suficiente, cambiamos al estado Perseguir
        if distancia < enemigo.distancia_vision:
            transicion.emit("Perseguir")
extends Estado

var zona_ataque: Area2D

func entrar():
    enemigo.velocity = Vector2.ZERO
    if animacion.current_animation != enemigo.anim_ataque:
        animacion.play(enemigo.anim_ataque)
        
    if not zona_ataque:
        zona_ataque = enemigo.get_node("Zona_ataque")
        
    # Conectamos la señal para saber cundo el jugador se aleja
    zona_ataque.body_exited.connect(_al_jugador_salir)

func salir():
    if zona_ataque.body_exited.is_connected(_al_jugador_salir):
        zona_ataque.body_exited.disconnect(_al_jugador_salir)

func _al_jugador_salir(cuerpo: Node2D):
    if cuerpo == enemigo.jugador:
        transicion.emit("Perseguir")

func actualizar_fisica(_delta: float):
    if not enemigo.jugador:
        return
        
    
    var direccion = enemigo.global_position.direction_to(enemigo.jugador.global_position)
    if direccion.x < 0:
        sprite.flip_h = true
    elif direccion.x > 0:
        sprite.flip_h = false
        
    # Sistema de daño a los cuerpos dentro de la zona
    var cuerpos_tocando = zona_ataque.get_overlapping_bodies()
    for cuerpo in cuerpos_tocando:
        if cuerpo == enemigo.jugador: 
            print("Atacando a: ", cuerpo.name)
            if cuerpo.has_method("recibir_dano"):
                cuerpo.recibir_dano(enemigo.dano_contacto)
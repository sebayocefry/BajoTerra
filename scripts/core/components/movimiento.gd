extends Node
class_name MovimientoPersonaje


func move(body: Entidad, direction: Vector2):
    if direction != Vector2.ZERO:
        # Aquí multiplicamos por la velocidad que viene del personaje (body)
        body.velocity = direction * body.velocidad
    else:
        body.velocity = Vector2.ZERO
    
    body.move_and_slide()
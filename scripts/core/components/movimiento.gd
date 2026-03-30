extends Node
class_name  movimentoPersonaje

@export var velocidad: float = 10000.0

# Esta función recibe el cuerpo que queremos mover y la dirección
func move(body: CharacterBody2D, direction: Vector2):
	if direction != Vector2.ZERO:
		body.velocity = direction * velocidad
	else:
		body.velocity = Vector2.ZERO
	
	body.move_and_slide()

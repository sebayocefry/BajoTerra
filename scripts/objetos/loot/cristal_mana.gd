extends Area2D



class_name CristalMana

@export var valor_mana: int = 20

# Esta señal se emite cuando alguien pisa el cristal
func _on_body_entered(body: Node2D):
	print("CRISTAL: Fui tocado por el nodo -> ", body.name)
	if body.has_method("sumar_mana"):
		print("CRISTAL: El nodo ES el jugador. Sumando maná y destruyendo cristal...")
		body.sumar_mana(valor_mana)
		queue_free() # El cristal se destruye tras ser recogido
	else:
		print("CRISTAL: El nodo toco el cristal, pero no sirve la funcion 'sumar_mana'")

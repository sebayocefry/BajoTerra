extends Area2D

class_name CristalMana

@export var valor_mana: int = 20

func _on_body_entered(body: Node2D):
	if body.has_method("sumar_mana"):
		body.sumar_mana(valor_mana)
		queue_free()

extends Area2D

class_name CristalOro

@export var valor_oro: int = 10

func _on_body_entered(body: Node2D):
	if body.has_method("sumar_oro"):
		body.sumar_oro(valor_oro)
		queue_free()

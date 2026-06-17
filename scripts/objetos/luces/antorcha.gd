extends StaticBody2D

func _ready():
	if has_node("AnimatedSprite2D"):
		$AnimatedSprite2D.play("default")

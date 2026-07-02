extends Node2D

@onready var audio: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	audio.play()
	audio.finished.connect(queue_free)
	if sprite.sprite_frames and sprite.sprite_frames.has_animation("default"):
		sprite.play("default")

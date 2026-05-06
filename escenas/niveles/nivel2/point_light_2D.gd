extends PointLight2D

@export var energia_min: float = 1.0
@export var energia_max: float = 1.3
@export var duracion: float = 2.0

func _ready():
	var tween = create_tween().set_loops()
	
	tween.tween_property(self, "energy", energia_max, duracion)
	tween.tween_property(self, "energy", energia_min, duracion)

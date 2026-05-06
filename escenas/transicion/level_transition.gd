extends CanvasLayer

@onready var color_rect: ColorRect = $ColorRect

var scene_to_load : String
var color_rect_tween: Tween 
var esta_transicionando := false

func change_scene_to(scene_path: String) -> void:
	if esta_transicionando:
		return
	
	esta_transicionando = true
	
	if color_rect_tween:
		color_rect_tween.kill()
		
	scene_to_load = scene_path
	
	color_rect_tween = create_tween().set_trans(Tween.TRANS_SINE)

	color_rect_tween.tween_property(
		color_rect.material,
		"shader_parameter/radius",
		1.2,
		1.5  # ⏱️ más lento
	)

	color_rect_tween.tween_callback(_load_new_scene)

	color_rect_tween.tween_property(
		color_rect.material,
		"shader_parameter/radius",
		0.0,
		1.0  # ⏱️ más lento también
	)

func _load_new_scene() -> void:
	get_tree().call_deferred("change_scene_to_file", scene_to_load)
	esta_transicionando = false

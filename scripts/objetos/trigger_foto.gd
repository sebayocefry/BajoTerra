extends Area2D
class_name TriggerFoto

@export var foto_a_mostrar: Texture2D
@export var pausar_juego: bool = true
@export var icono_personalizado: Texture2D
@export var tamano_maximo: float = 200.0

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	
	if icono_personalizado != null and has_node("Sprite2D"):
		$Sprite2D.texture = icono_personalizado
		
		# Ajustar el tamaño para que no sea gigante
		var image_size = icono_personalizado.get_size()
		if image_size.x > tamano_maximo or image_size.y > tamano_maximo:
			var scale_factor = min(tamano_maximo / image_size.x, tamano_maximo / image_size.y)
			$Sprite2D.scale = Vector2(scale_factor, scale_factor)

func _on_body_entered(body: Node2D):
	if body.is_in_group("player") or body.is_in_group("jugador") or body.is_in_group("Jugador"):
		if foto_a_mostrar:
			Eventos.emit_signal("mostrar_foto", foto_a_mostrar)
			if pausar_juego:
				get_tree().paused = true

func _on_body_exited(body: Node2D):
	if body.is_in_group("player") or body.is_in_group("jugador") or body.is_in_group("Jugador"):
		Eventos.emit_signal("ocultar_foto")
		if pausar_juego:
			get_tree().paused = false

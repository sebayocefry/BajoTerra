extends Area2D

@export_multiline var mensaje: String = "Usa las teclas WASD para moverte."
@export var ocultar_al_salir: bool = true
@export var icono_personalizado: Texture2D
@export var tamano_maximo: float = 200.0

func _ready():
	# Nos aseguramos de que el trigger responda a las colisiones
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	
	if icono_personalizado != null:
		$Sprite2D.texture = icono_personalizado
		
		# Ajustar el tamaño para que no sea gigante
		var image_size = icono_personalizado.get_size()
		if image_size.x > tamano_maximo or image_size.y > tamano_maximo:
			var scale_factor = min(tamano_maximo / image_size.x, tamano_maximo / image_size.y)
			$Sprite2D.scale = Vector2(scale_factor, scale_factor)


func _on_body_entered(body: Node2D):
	if body.is_in_group("player") or body.is_in_group("jugador") or body.is_in_group("Jugador"):
		# Duracion 0 significa que se queda visible hasta que salgamos
		var duracion = 0.0 if ocultar_al_salir else 4.0
		Eventos.emit_signal("mostrar_mensaje_tutorial", mensaje, duracion)

func _on_body_exited(body: Node2D):
	if ocultar_al_salir and (body.is_in_group("player") or body.is_in_group("jugador") or body.is_in_group("Jugador")):
		Eventos.emit_signal("ocultar_mensaje_tutorial")

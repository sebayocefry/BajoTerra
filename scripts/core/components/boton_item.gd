extends Button
class_name BotonItemTienda

signal item_presionado(objeto_seleccionado: Objeto)

@onready var icono_rect: TextureRect = %TextureRect
@onready var label_texto: Label = %Label

var objeto_vinculado: Objeto = null

func _ready() -> void:
	assert(icono_rect != null, "CRÍTICO: No se encontró %TextureRect")
	assert(label_texto != null, "CRÍTICO: No se encontró %Label")
	
	call_deferred("_centrar_pivote")
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	pressed.connect(_on_boton_interno_presionado)

func _centrar_pivote() -> void:
	pivot_offset = size / 2.0

func configurar(nuevo_objeto: Objeto) -> void:
	objeto_vinculado = nuevo_objeto
	label_texto.text = "%s - %d Oro" % [objeto_vinculado.nombre, objeto_vinculado.precio_oro]
	
	if objeto_vinculado.icono != null:
		icono_rect.texture = objeto_vinculado.icono
	else:
		icono_rect.texture = null 

#codigo sacado de internet para darle como una animacion al  boton de la tienda:

func _on_mouse_entered() -> void:

	var tween = create_tween().set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	
	# Animamos el crecimiento a 105% (1.05) en 0.1 segundos
	tween.tween_property(self, "scale", Vector2(1.05, 1.05), 0.1)

func _on_mouse_exited() -> void:
	var tween = create_tween().set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	
	# Volvemos al tamaño original 100% (1.0) en 0.1 segundos
	tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.1)

# aca termina lo sacado de net

func _on_boton_interno_presionado() -> void:
	if objeto_vinculado != null:
		item_presionado.emit(objeto_vinculado)

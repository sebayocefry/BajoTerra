extends CanvasLayer

@onready var barra_vida = %BarraVida
@onready var texto_mana = %TextoMana
@onready var texto_oro = %TextoOro
@onready var icono_arma = %IconoArma
@onready var icono_objeto = %IconoObjeto
@onready var icono_objeto2 = %IconoObjeto2
@onready var imagen_guardado = %ImagenGuardado
@onready var contenedor_tutorial = $ContenedorTutorial
@onready var mensaje_tutorial = %MensajeTutorial

var fondo_foto: ColorRect
var imagen_foto: TextureRect

func _ready():
	Eventos.vida_actualizada.connect(_on_vida_actualizada)
	Eventos.mana_actualizado.connect(_on_mana_actualizado)
	Eventos.oro_actualizado.connect(_on_oro_actualizado)
	Eventos.arma_equipada_cambiada.connect(_on_arma_cambiada)
	Eventos.consumible_equipado_cambiado.connect(_on_objeto_cambiado)
	Eventos.progreso_guardado.connect(_on_progreso_guardado)
	Eventos.mostrar_mensaje_tutorial.connect(_on_mostrar_mensaje_tutorial)
	Eventos.ocultar_mensaje_tutorial.connect(_on_ocultar_mensaje_tutorial)
	Eventos.mostrar_foto.connect(_on_mostrar_foto)
	Eventos.ocultar_foto.connect(_on_ocultar_foto)
	imagen_guardado.texture = load("res://assets/Fondos/partida_guardad.png")
	
	_crear_nodos_foto()

func _crear_nodos_foto():
	fondo_foto = ColorRect.new()
	fondo_foto.color = Color(0, 0, 0, 0.8) # Fondo semi-transparente
	fondo_foto.set_anchors_preset(Control.PRESET_FULL_RECT)
	fondo_foto.visible = false
	fondo_foto.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(fondo_foto)
	
	imagen_foto = TextureRect.new()
	imagen_foto.set_anchors_preset(Control.PRESET_FULL_RECT)
	imagen_foto.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	imagen_foto.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	imagen_foto.visible = false
	imagen_foto.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(imagen_foto)

func _on_mostrar_foto(textura: Texture2D):
	if imagen_foto and fondo_foto:
		imagen_foto.texture = textura
		fondo_foto.visible = true
		imagen_foto.visible = true

func _on_ocultar_foto():
	if imagen_foto and fondo_foto:
		fondo_foto.visible = false
		imagen_foto.visible = false

func _on_vida_actualizada(v_actual: int, v_max: int):
	if barra_vida:
		barra_vida.max_value = v_max
		var tween = get_tree().create_tween()
		tween.tween_property(barra_vida, "value", v_actual, 0.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

func _on_mana_actualizado(m_actual: int):
	if texto_mana:
		texto_mana.text = "Mana: " + str(m_actual)

func _on_oro_actualizado(oro_actual: int):
	if texto_oro:
		texto_oro.text = "Oro: " + str(oro_actual)

func _on_arma_cambiada(nuevo_sprite: Texture2D):
	if icono_arma:
		icono_arma.texture = nuevo_sprite

func _on_objeto_cambiado(icono1: Texture2D, icono2: Texture2D, slot_activo: int):
	if icono_objeto:
		icono_objeto.texture = icono1
		icono_objeto.get_parent().modulate = Color(1, 1, 1, 1) if slot_activo == 1 else Color(0.5, 0.5, 0.5, 1)
	if icono_objeto2:
		icono_objeto2.texture = icono2
		icono_objeto2.get_parent().modulate = Color(1, 1, 1, 1) if slot_activo == 2 else Color(0.5, 0.5, 0.5, 1)

func _on_progreso_guardado():
	var tween = create_tween()
	# Aparece en 0.3s
	tween.tween_property(imagen_guardado, "modulate:a", 1.0, 0.3).set_trans(Tween.TRANS_SINE)
	# Espera 2.5s visible
	tween.tween_interval(2.5)
	# Desaparece en 0.5s
	tween.tween_property(imagen_guardado, "modulate:a", 0.0, 0.5).set_trans(Tween.TRANS_SINE)

func _on_mostrar_mensaje_tutorial(texto: String, duracion: float):
	if mensaje_tutorial and contenedor_tutorial:
		mensaje_tutorial.text = texto
		contenedor_tutorial.visible = true
		
		var tween = create_tween()
		tween.tween_property(contenedor_tutorial, "modulate:a", 1.0, 0.3).set_trans(Tween.TRANS_SINE)
		
		# Si duracion es mayor a 0, se oculta automaticamente
		if duracion > 0.0:
			tween.tween_interval(duracion)
			tween.tween_property(contenedor_tutorial, "modulate:a", 0.0, 0.3).set_trans(Tween.TRANS_SINE)
			tween.tween_callback(func(): contenedor_tutorial.visible = false)

func _on_ocultar_mensaje_tutorial():
	if contenedor_tutorial and contenedor_tutorial.visible:
		var tween = create_tween()
		tween.tween_property(contenedor_tutorial, "modulate:a", 0.0, 0.3).set_trans(Tween.TRANS_SINE)
		tween.tween_callback(func(): contenedor_tutorial.visible = false)

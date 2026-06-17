extends CanvasLayer

@onready var barra_vida = %BarraVida
@onready var texto_mana = %TextoMana
@onready var texto_oro = %TextoOro
@onready var icono_arma = %IconoArma
@onready var icono_objeto = %IconoObjeto
@onready var imagen_guardado = %ImagenGuardado

func _ready():
	Eventos.vida_actualizada.connect(_on_vida_actualizada)
	Eventos.mana_actualizado.connect(_on_mana_actualizado)
	Eventos.oro_actualizado.connect(_on_oro_actualizado)
	Eventos.arma_equipada_cambiada.connect(_on_arma_cambiada)
	Eventos.consumible_equipado_cambiado.connect(_on_objeto_cambiado)
	Eventos.progreso_guardado.connect(_on_progreso_guardado)
	imagen_guardado.texture = load("res://assets/Fondos/partida_guardad.png")

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

func _on_objeto_cambiado(nuevo_sprite: Texture2D):
	if icono_objeto:
		icono_objeto.texture = nuevo_sprite

func _on_progreso_guardado():
	var tween = create_tween()
	# Aparece en 0.3s
	tween.tween_property(imagen_guardado, "modulate:a", 1.0, 0.3).set_trans(Tween.TRANS_SINE)
	# Espera 2.5s visible
	tween.tween_interval(2.5)
	# Desaparece en 0.5s
	tween.tween_property(imagen_guardado, "modulate:a", 0.0, 0.5).set_trans(Tween.TRANS_SINE)

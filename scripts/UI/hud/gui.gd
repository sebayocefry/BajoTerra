extends CanvasLayer

# --- INSTRUCCIONES PARA LAURA ---
# Estas rutas ($) deben coincidir exactamente con los nombres en el arbol de nodos.
# Si renombras un nodo en el panel de la izquierda, debes cambiarlo aquí también.
# ---------------------------------

@onready var barra_vida = $MarginContainer/VBoxContainer/BarraVida
@onready var texto_mana = $MarginContainer/VBoxContainer/FilaInferior/TextoMana
@onready var icono_arma = $MarginContainer/VBoxContainer/FilaInferior/CajaArma/Icono
@onready var icono_objeto = $MarginContainer/VBoxContainer/FilaInferior/CajaObjeto/Icono

func _ready():
    Eventos.vida_actualizada.connect(_on_vida_actualizada)
    Eventos.mana_actualizado.connect(_on_mana_actualizado)
    Eventos.arma_equipada_cambiada.connect(_on_arma_cambiada)
    Eventos.consumible_equipado_cambiado.connect(_on_objeto_cambiado)

#  Reacciones (Defensivas: validamos que el nodo exista antes de cambiarlo)
func _on_vida_actualizada(v_actual: int, v_max: int):
    if barra_vida:
        barra_vida.max_value = v_max
        barra_vida.value = v_actual

func _on_mana_actualizado(m_actual: int):
    if texto_mana:
        texto_mana.text = str(m_actual)

func _on_arma_cambiada(nuevo_sprite: Texture2D):
    if icono_arma:
        icono_arma.texture = nuevo_sprite

func _on_objeto_cambiado(nuevo_sprite: Texture2D):
    if icono_objeto:
        icono_objeto.texture = nuevo_sprite
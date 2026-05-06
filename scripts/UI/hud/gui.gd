extends CanvasLayer

# --- INSTRUCCIONES PARA LAURA ---
# Estas rutas ($) deben coincidir exactamente con los nombres en el arbol de nodos.
# Si renombras un nodo en el panel de la izquierda, debes cambiarlo aquí también.
# ---------------------------------

@onready var barra_vida = %BarraVida
@onready var texto_mana = %TextoMana
@onready var icono_arma = %IconoArma
@onready var icono_objeto = %IconoObjeto

func _ready():
    Eventos.vida_actualizada.connect(_on_vida_actualizada)
    Eventos.mana_actualizado.connect(_on_mana_actualizado)
    Eventos.arma_equipada_cambiada.connect(_on_arma_cambiada)
    Eventos.consumible_equipado_cambiado.connect(_on_objeto_cambiado)

#  Reacciones (Defensivas: validamos que el nodo exista antes de cambiarlo)
func _on_vida_actualizada(v_actual: int, v_max: int):
    #print("GUI ESCUCH LA SEnAL: Vida = ", v_actual, " / ", v_max)
    if barra_vida:
        barra_vida.max_value = v_max
        #paara reakizar una animacion al bajar vida 
        var tween = get_tree().create_tween()
        tween.tween_property(barra_vida, "value", v_actual, 0.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
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
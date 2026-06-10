extends CharacterBody2D
# Variables básicas que antes venían del padre
@export var velocidad = 50.0
@export var vida = 100
@export var vida_maxima = 100
@export var dano_contacto = 10

var jugador = null
var jugador_en_rango = false

# Referencia a la máquina (Asegúrate que el nombre coincida con tu árbol)
@onready var maquina_estados = $Maquina_estados

func morir():
	# Buscamos el nodo Maquina_estados que está colgado del Boss
	var maquina = get_node_or_null("Maquina_estados")
	
# Conecta las señales de tu Zona_ataque (la del slime chico) a estas funciones
func _on_zona_ataque_body_entered(body):
	if body.is_in_group("jugador"):
		jugador = body
		jugador_en_rango = true

func _on_zona_ataque_body_exited(body):
	if body.is_in_group("jugador"):
		jugador_en_rango = false

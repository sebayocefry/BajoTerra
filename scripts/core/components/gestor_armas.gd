extends Node2D
class_name Gestor_armas

@export var arma_inicial : Arma

@onready var sprite_arma = $SpriteArma
@onready var mano = $Mano # Este es tu punto físico de disparo


# Aqu guardamos el Resource (Objeto) que el jugador se equipo desde el inventario
var arma_equipada: Arma 

func _ready():
	if arma_inicial:
		equipar_arma(arma_inicial)

func equipar_arma(nueva_arma: Arma):
	arma_equipada = nueva_arma
	# Actualizamos el dibujo en pantalla con el icono del inventario
	sprite_arma.texture = arma_equipada.icono 

func actualizar_apuntado(direccion_texto: String):
	var distancia = 15
	match direccion_texto:
		"up": position = Vector2(0, -distancia)
		"down": position = Vector2(0, distancia)
		"left": position = Vector2(-distancia, 0)
		"right": position = Vector2(distancia, 0)

func apretar_gatillo(direccion_texto: String):
	if arma_equipada:
		var vector_disparo = Vector2.ZERO
		match direccion_texto:
			"up": vector_disparo = Vector2.UP
			"down": vector_disparo = Vector2.DOWN
			"left": vector_disparo = Vector2.LEFT
			"right": vector_disparo = Vector2.RIGHT
			
		# Le pasamos el Player (owner), la dirección, Y LA POSICIÓN FÍSICA de la mano
		arma_equipada.disparar(owner as Player, vector_disparo, mano.global_position)
	else:
		print("Intentaste disparar, pero no hay arma equipada")

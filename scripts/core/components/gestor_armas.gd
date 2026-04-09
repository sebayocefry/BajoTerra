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

func _process(_delta):
	apuntar_al_raton()

func equipar_arma(nueva_arma: Arma):
	arma_equipada = nueva_arma
	# Actualizamos el dibujo en pantalla con el icono del inventario
	sprite_arma.texture = arma_equipada.icono 
	#Laura aca se conecta el arma 
	Eventos.arma_equipada_cambiada.emit(arma_equipada.icono)

#func actualizar_apuntado(direccion_texto: String):
#	var distancia = 15
#	match direccion_texto:
#		"up": position = Vector2(0, -distancia)
#		"down": position = Vector2(0, distancia)
#		"left": position = Vector2(-distancia, 0)
#		"right": position = Vector2(distancia, 0)



func apuntar_al_raton():
	var posicion_raton = get_global_mouse_position()
	look_at(posicion_raton)

	#para que no se vea como la pistola boca a bajo o entrando al cuerpo del jugador cuando cambiamos de lado la mira
	if posicion_raton.x < global_position.x:
		sprite_arma.flip_v = true
	else:
		sprite_arma.flip_v = false



func apretar_gatillo():
	if arma_equipada:
		var vector_disparo = global_position.direction_to(get_global_mouse_position())	
		# Le pasamos el Player (owner), la dirección, Y LA POSICIÓN FÍSICA de la mano
		arma_equipada.disparar(owner as Player, vector_disparo, mano.global_position)
	else:
		print("Intentaste disparar, pero no hay arma equipada")

extends Node
class_name EstadoJefe

var enemigo : EnemigoJefeBrr
var animacion : AnimationPlayer
var sprite_chico : Sprite2D
var sprite_demonio : Sprite2D

signal transicion(nuevo_estado_nombre : String)

func entrar():
	pass

func actualizar_fisica(_delta : float):
	pass

func salir():
	pass

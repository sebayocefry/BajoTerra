extends Node 
class_name Estado

#refactorizacion: se cambia Enemigo por Entidad para asi poder usarlo en todas las clases
#Se quita la restriccion que solo sea Sprite2d 
var enemigo : Enemigo 
var animacion : AnimationPlayer
var sprite : Sprite2D
var actor : Entidad 
var animador 
var visual 

signal transicion(nuevo_estado_nombre : String)

func entrar():
	pass

func actualizar_fisica(_delta : float):
	pass

func salir():
	pass
	
func manejar_input(_evento : InputEvent):
	pass

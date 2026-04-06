extends Node 
class_name Estado

var enemigo : Enemigo 
var animacion : AnimationPlayer
var sprite : Sprite2D

signal transicion(nuevo_estado_nombre : String)

func entrar():
    pass

func actualizar_fisica(_delta : float):
    pass

func salir():
    pass

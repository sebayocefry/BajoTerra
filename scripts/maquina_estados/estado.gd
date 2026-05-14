extends Node 
class_name Estado

var actor : Entidad 
# Quitamos el tipado estricto (no le ponemos ': AnimationPlayer' ni ': Sprite2D')
# Esto nos permite inyectarle cualquier nodo que cumpla con la función
var animador 
var visual 

signal transicion(nuevo_estado_nombre : String)

func entrar():
    pass

func actualizar_fisica(_delta : float):
    pass

func manejar_input(_evento : InputEvent):
    pass

func salir():
    pass
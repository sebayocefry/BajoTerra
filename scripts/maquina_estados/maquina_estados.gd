extends Node

class_name Maquina_estados

@export var estado_inicial : NodePath

var estado_actual : Estado

func  _ready():
    #esto le dice que espere para que asi el programa no intente tomar nulos antes de que esten listos
    await owner.ready 
    for hijo in get_children():
        if hijo is Estado:
            hijo.enemigo = owner as Enemigo
            hijo.animacion = owner.find_child("AnimationPlayer")
            hijo.sprite = owner.find_child("Sprite2D")
            #e evento para cambiar de estado
            hijo.transicion.connect(_al_cambiar_estado)


    if estado_inicial:
        estado_actual = get_node(estado_inicial)
        estado_actual.entrar()
    
func _physics_process(delta):
    if estado_actual:
        #print("ESTADO ACTIVO: ", estado_actual.name)
        estado_actual.actualizar_fisica(delta)
    else:
        print("ERROR: La máquina no tiene un estado actual")


func _al_cambiar_estado(nuevo_estado_n : String):
    var nuevo_estado = get_node_or_null(nuevo_estado_n)
    if nuevo_estado and nuevo_estado != estado_actual:
        estado_actual.salir()
        estado_actual = nuevo_estado
        estado_actual.entrar()


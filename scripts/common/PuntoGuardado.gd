extends Area2D

var jugador_cerca: Player = null

func _ready():
    body_entered.connect(_on_body_entered)
    body_exited.connect(_on_body_exited)

func _unhandled_input(event):
    if jugador_cerca and event.is_action_pressed("interactuar"):
        print("El NPC asiente. Tu progreso ha sido registrado.")
        
        #  Actualizamos la RAM con el estado ACTUAL del jugador antes de guardar
        DatosJugador.guardar_estado_jugador(jugador_cerca)
        
        #  Ordenamos escribir en el disco
        SistemaGuardado.guardar_partida()
        
       

func _on_body_entered(body: Node2D):
    if body is Player:
        jugador_cerca = body
        print("Presiona 'E' para descansar y guardar partida.")

func _on_body_exited(body: Node2D):
    if body == jugador_cerca:
        jugador_cerca = null
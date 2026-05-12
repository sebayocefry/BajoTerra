extends Area2D
class_name PuertaTransicion

# Expone en el inspector que habitacion cargar y en que coordenada (x,y) debe aparecer el minero
@export_file("*.tscn") var siguiente_habitacion: String
@export var coordenada_destino: Vector2

func _ready():
    body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D):
    if body is Player:
        # Apagamos el monitoreo temporalmente para evitar que la fisica 
        # dispare la señal 60 veces en un segundo si el jugador se queda parado 
        set_deferred("monitoring", false) 
        
        Eventos.transicion_habitacion_solicitada.emit(siguiente_habitacion, coordenada_destino)
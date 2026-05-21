extends Node2D
class_name Gestor_armas

@onready var sprite_arma = $SpriteArma
@onready var mano = $Mano 
@export var armas_disponibles : Array[Arma] = []

var indice_arma_actual: int = 0
var arma_equipada: Arma 

var tiempo_enfriamiento: float = 0.0 

func inicializar_armas() -> void:
    if armas_disponibles.size() > 0 and armas_disponibles[0] != null:
        equipar_arma(armas_disponibles[0]) 

func _process(delta: float) -> void:

    if tiempo_enfriamiento > 0.0:
        tiempo_enfriamiento -= delta
    procesar_disparo(delta)

func procesar_disparo(_delta: float) -> void:
    if not arma_equipada: return
    
    
    var vector_disparo = Input.get_vector("disparar_izq", "disparar_der", "disparar_arriba", "disparar_abajo")
    
    if vector_disparo != Vector2.ZERO:
  
        if abs(vector_disparo.x) > abs(vector_disparo.y):
            vector_disparo.y = 0
        else:
            vector_disparo.x = 0
            
        vector_disparo = vector_disparo.normalized()
        
        # Orientamos el arma visualmente
        rotation = vector_disparo.angle()
        sprite_arma.flip_v = vector_disparo.x < 0
        
        # Disparamos solo si el arma se ha pasaso los segundos
        if tiempo_enfriamiento <= 0.0:
            apretar_gatillo(vector_disparo)

func apretar_gatillo(direccion: Vector2) -> void:
    # Reiniciamos el reloj leyendo la cadencia directamente de la entidad Arma
    tiempo_enfriamiento = arma_equipada.cadencia
    arma_equipada.disparar(owner as Player, direccion, mano.global_position)

func _unhandled_input(event):
    if event.is_action_pressed("arma_siguiente"):
        cambiar_arma(1)
    elif event.is_action_pressed("arma_anterior"):
        cambiar_arma(-1)

func cambiar_arma(direccion: int):
    if armas_disponibles.size() <= 1: return 
    
    indice_arma_actual += direccion
    if indice_arma_actual >= armas_disponibles.size():
        indice_arma_actual = 0
    elif indice_arma_actual < 0:
        indice_arma_actual = armas_disponibles.size() - 1
        
    equipar_arma(armas_disponibles[indice_arma_actual])

func equipar_arma(nueva_arma: Arma):
    arma_equipada = nueva_arma
    sprite_arma.texture = arma_equipada.icono 
    tiempo_enfriamiento = arma_equipada.cadencia  
    Eventos.arma_equipada_cambiada.emit(arma_equipada.icono)
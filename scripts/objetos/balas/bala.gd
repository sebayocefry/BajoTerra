extends Area2D
class_name Bala

@export var velocidad: float = 400.0

# Estas variables las reescribe el Arma justo en el milisegundo que la dispara
var direccion: Vector2 = Vector2.ZERO 
var dano: int = 0 

func _ready():
    # Opcional: Hace que la bala apunte visualmente hacia donde viaja
    rotation = direccion.angle()

func _physics_process(delta: float):
    # Movimiento constante en la dirección asignada
    position += direccion * velocidad * delta

# Esta señal se dispara cuando la bala toca CUALQUIER cuerpo físico
func _on_body_entered(cuerpo: Node2D):
    # Duck Typing: No preguntamos qué es, preguntamos si puede recibir daño.
    # Excluimos al Player para que no se dispare a sí mismo.
    if cuerpo.has_method("recibir_dano") and not cuerpo is Player:
        cuerpo.recibir_dano(dano)
        queue_free() # Destruye la bala al impactar
        
    # Si choca contra una pared (TileMap) u otro obstáculo del mundo, se destruye
    elif cuerpo is TileMap:
        queue_free()

# Como medida de seguridad (Clean Code), borramos la bala si sale de la pantalla
# Para esto, agrégale un nodo 'VisibleOnScreenNotifier2D' a la escena de tu bala y conecta su señal:
func _on_visible_on_screen_notifier_2d_screen_exited():
    queue_free()
extends Objeto
class_name Arma

# Atributos de las armas
@export var dano: int = 20
@export var costo_mana: int = 10
@export var critico: float = 0.0
@export var cadencia: float = 0.4 

@export var escena_bala : PackedScene

func disparar(jugador: Player, direccion: Vector2, punto_disparo : Vector2) -> void:
    if jugador.mana >= costo_mana:
        jugador.mana -= costo_mana
        ejecutar_disparo(jugador, direccion, punto_disparo)
    else:
        print("No hay mana suficiente para usar ", nombre) 

func ejecutar_disparo(jugador: Player, direccion: Vector2, punto_disparo: Vector2):
    if not escena_bala:
        print("ERROR: El arma no tiene escena de bala asignada.")
        return
        
    var dano_final = dano
    if randf() <= critico:
        dano_final *= 2
        print("¡GOLPE CRITICO!")
        
    var nueva_bala = escena_bala.instantiate()
    
    # Coordenadas y variables fisicas
    nueva_bala.global_position = punto_disparo 
    
    if "direccion" in nueva_bala:
        nueva_bala.direccion = direccion
        
    if "dano" in nueva_bala:
        nueva_bala.dano = dano_final 
        
    jugador.get_tree().current_scene.add_child(nueva_bala)
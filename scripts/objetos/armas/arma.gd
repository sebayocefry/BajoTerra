extends Objeto
class_name Arma

# Atributos de las armas
@export var dano: int = 20
@export var costo_mana: int = 10
@export var critico: float = 0.0

@export var escena_bala : PackedScene

func disparar(jugador: Player, direccion: Vector2, punto_disparo : Vector2) -> void:
	
	
	if jugador.mana >= costo_mana:
		jugador.mana -= costo_mana
		
		#  Procedemos a ejecutar el disparo físico
		ejecutar_disparo(jugador,direccion,punto_disparo)
	else:
		# Aquí más adelante podrías reproducir un sonido de "arma vacía"
		print("No hay maná suficiente para usar ", nombre) # nombre hace referencia al nombre del objeto, no jugador 


func ejecutar_disparo(jugador: Player, direccion: Vector2, punto_disparo: Vector2):
	if not escena_bala:
		print("ERROR: El arma no tiene escena de bala asignada.")
		return
		
	var dano_final = dano
	if randf() <= critico:
		dano_final *= 2
		print("¡GOLPE CRÍTICO!")
		
	var nueva_bala = escena_bala.instantiate()
	
	#  Usamos la coordenada fisica que nos paso el GestorArmas
	nueva_bala.global_position = punto_disparo 
	
	if "direccion" in nueva_bala:
		nueva_bala.direccion = direccion
		
	if "dano" in nueva_bala:
		nueva_bala.dano = dano_final 
		
	#  Usamos los "ojos" del jugador para acceder al nivel actual
	jugador.get_tree().current_scene.add_child(nueva_bala)

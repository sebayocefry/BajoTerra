extends Objeto
class_name Arma

# Atributos de las armas
@export var dano: int = 20
@export var costo_mana: int = 10
@export var critico: float = 0.0
@export var cadencia: float = 0.4

@export var escena_bala: PackedScene

# Brazo visual por dirección (texturas y posiciones)
@export_group("Brazo")
@export var brazo_textura_abajo: Texture2D
@export var brazo_textura_arriba: Texture2D
@export var brazo_textura_derecha: Texture2D
@export var brazo_textura_izquierda: Texture2D
@export var brazo_offset_abajo: Vector2 = Vector2.ZERO
@export var brazo_offset_arriba: Vector2 = Vector2.ZERO
@export var brazo_offset_derecha: Vector2 = Vector2.ZERO
@export var brazo_offset_izquierda: Vector2 = Vector2.ZERO
@export var brazo_escala: Vector2 = Vector2(1.0, 1.0)

func disparar(jugador: Player, direccion: Vector2, punto_disparo : Vector2) -> void:
	if jugador.mana >= costo_mana:
		jugador.mana -= costo_mana
		Eventos.mana_actualizado.emit(jugador.mana)
		ejecutar_disparo(jugador, direccion, punto_disparo)
	else:
		print("No hay maná suficiente para usar ", nombre)


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

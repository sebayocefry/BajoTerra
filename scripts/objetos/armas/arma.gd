extends Objeto
class_name Arma

# Atributos de las armas
@export var dano: int = 20
@export var costo_mana: int = 10
@export var critico: float = 0.0

func usar(jugador: CharacterBody2D) -> void:
	if jugador.mana >= costo_mana:
		jugador.mana -= costo_mana
		atacar(jugador)
	else:
		print("No hay maná suficiente para usar ", nombre)

func atacar(jugador: CharacterBody2D):
	var dano_final = dano

	if randf() <= critico:
		dano_final *= 2
		print("¡GOLPE CRÍTICO!")
	
	print(jugador.nombre, " atacó con ", nombre, " causando ", dano_final, " de daño.")
	print("Maná restante: ", jugador.mana)
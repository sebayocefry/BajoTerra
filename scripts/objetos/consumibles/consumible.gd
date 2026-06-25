extends Objeto 
class_name Consumible

@export var cura_vida: int = 0
@export var recupera_mana: int = 0

func usar(jugador: CharacterBody2D) -> void:
	
	# Sumamos las estadísticas al jugador. 
	# Si la poción no da maná (es 0), sumar 0 no afecta en nada.
	#asi tambien si queremos usar mas consumibles o uno mixto no tocamos tanto 
	
	if jugador is Player:
		if cura_vida != 0:
			jugador.curar(cura_vida)
		if recupera_mana != 0:
			jugador.sumar_mana(recupera_mana)
		
		# Como ya sabemos que es el Player, Godot reconoce nombre_entidad, vida y mana
		print(jugador.nombre_entidad, " usó ", nombre, ". Vida actual: ", jugador.vida, " | Maná: ", jugador.mana)

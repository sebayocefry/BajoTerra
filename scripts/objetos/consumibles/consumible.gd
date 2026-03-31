extends Objeto 
class_name Consumible

# Atributos exclusivos de los consumibles
#los ponemos doble en vez de separarlo en clases distintas como java, para asi aprovechar la creacion visual de godot 
@export var cura_vida: int = 0
@export var recupera_mana: int = 0

# el metodo abstracto de objeto
func usar(jugador: CharacterBody2D) -> void:
	# Sumamos las estadísticas al jugador. 
	# Si la poción no da maná (es 0), sumar 0 no afecta en nada.
	#asi tambien si queremos usar mas consumibles o uno mixto no tocamos tanto 
	jugador.vida += cura_vida
	jugador.mana += recupera_mana
	
	#para debugear a futuro
	print(jugador.nombre, " usó ", nombre, ". Vida actual: ", jugador.vida, " | Maná: ", jugador.mana)

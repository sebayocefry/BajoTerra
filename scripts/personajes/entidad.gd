extends CharacterBody2D

class_name Entidad 
#clase padre para jugador, enemigos y todo 
#estos atributos los usaran todos, jugador, enemigos, jefes etc

@export var vida_maxima : int = 100
@export var nombre_entidad : String = "npc"
@export var velocidad : int = 75 # Reducido de 100 a 75 para que los enemigos no sean tan rápidos
#sin export porque no queremos que se modifique en el editor 
var estado_invulnerable : bool = false
var empuje_actual: Vector2 = Vector2.ZERO
var vida : int 

signal entidad_morir

func _ready():
	vida = vida_maxima

# Función universal de daño
func recibir_dano(cantidad: int, vector_empuje: Vector2 = Vector2.ZERO):
	if estado_invulnerable:
		return 
	vida -= cantidad
	empuje_actual = vector_empuje
	print(nombre_entidad, " recibió ", cantidad, " de daño. Vida restante: ", vida)
	
	# --- FEEDBACK VISUAL ---
	_aplicar_hit_flash()
	
	# Temblor de cámara (más fuerte si es el jugador, suave si es un enemigo)
	if self.is_in_group("player"):
		Eventos.sacudir_camara.emit(2.0, 0.2)
	else:
		Eventos.sacudir_camara.emit(0.5, 0.1)
	
	if vida <= 0:
		morir()

func _aplicar_hit_flash():
	var sprite_node = get_node_or_null("Sprite2D")
	if not sprite_node:
		sprite_node = get_node_or_null("AnimatedSprite2D")
		
	if sprite_node:
		var material = sprite_node.material as ShaderMaterial
		if not material:
			material = ShaderMaterial.new()
			material.shader = preload("res://recursos/shaders/hit_flash.gdshader")
			sprite_node.material = material
		
		material.set_shader_parameter("active", true)
		await get_tree().create_timer(0.1).timeout
		if is_instance_valid(sprite_node) and is_instance_valid(material):
			material.set_shader_parameter("active", false)

func morir():
	entidad_morir.emit()
	queue_free()
	

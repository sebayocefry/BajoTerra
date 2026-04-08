extends CharacterBody2D

var speed = 700.0
var paketeBala = preload("res://escenas/niveles/extra_brr/bala.tscn")

func _physics_process(_delta):
	var direction = Input.get_vector("left", "right", "up", "down")
	velocity = direction * speed
	
	look_at_mouse()
	if Input.is_action_just_pressed("ui_accept"):
		shoot()
	
	move_and_slide()
	
	
func look_at_mouse():
	var mouse_pos = get_global_mouse_position()
	get_node("mano").look_at(mouse_pos)
func shoot():
	var nueva_bala = paketeBala.instantiate()
	nueva_bala.pos = $disparo.global_position
	nueva_bala.rota = $mano.global_rotation
	nueva_bala.dir = $mano.global_rotation
	get_parent().add_child(nueva_bala)
	
	get_parent().add_child(nueva_bala)
	

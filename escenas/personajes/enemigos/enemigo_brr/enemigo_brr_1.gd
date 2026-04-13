extends Enemigo # Aquí ya tienes maquina_estados, animacion, sprite, etc.

func _ready():
	# Llamamos al ready del padre para que busque al jugador
	super._ready() 
	
	# Podemos cambiar valores heredados solo para este enemigo
	distancia_vision = 500.0 
	dano_contacto = 25
	
	print("Soy un Brr1, tengo más visión que un enemigo normal")

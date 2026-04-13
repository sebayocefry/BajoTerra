extends "res://scripts/personajes/enemigos/enemigo.gd"
func _ready():
	# Esto es obligatorio para que busque al jugador al empezar
	super._ready() 
	print("Esqueleto listo y heredando de Enemigo")

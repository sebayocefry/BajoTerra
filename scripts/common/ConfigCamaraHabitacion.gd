@tool
extends Node2D
class_name ConfigCamaraHabitacion

## Si es mayor a 0, fuerza este zoom en vez de calcularlo automáticamente
## según el tamaño del TextureRect de la habitación.
@export var zoom_manual: float = 0.0:
	set(value):
		zoom_manual = value
		queue_redraw()

## Si se activa, usa estos límites en vez de los bordes del TextureRect
## (útil cuando paredes/puertas sobresalen del piso y la cámara los corta).
## IMPORTANTE: este nodo debe quedar en posición (0,0) dentro de la habitación
## para que el rectángulo dibujado coincida con lo que usa GestorNivel.
@export var usar_limites_manuales: bool = false:
	set(value):
		usar_limites_manuales = value
		queue_redraw()

@export var limite_izquierdo: float = 0.0:
	set(value):
		limite_izquierdo = value
		queue_redraw()

@export var limite_superior: float = 0.0:
	set(value):
		limite_superior = value
		queue_redraw()

@export var limite_derecho: float = 0.0:
	set(value):
		limite_derecho = value
		queue_redraw()

@export var limite_inferior: float = 0.0:
	set(value):
		limite_inferior = value
		queue_redraw()


func _ready() -> void:
	queue_redraw()


func _draw() -> void:
	if not Engine.is_editor_hint():
		return
	if not usar_limites_manuales:
		return

	var rect := Rect2(
		Vector2(limite_izquierdo, limite_superior),
		Vector2(limite_derecho - limite_izquierdo, limite_inferior - limite_superior)
	)

	draw_rect(rect, Color(1.0, 1.0, 0.0, 0.12), true)
	draw_rect(rect, Color(1.0, 1.0, 0.0, 1.0), false, 4.0)

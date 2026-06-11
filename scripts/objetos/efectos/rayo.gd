extends Node2D

@export var color_rayo := Color(0.6, 0.7, 1.0, 1.0)
@export var intervalo_min: float = 1.5
@export var intervalo_max: float = 4.0
@export var duracion_flash: float = 0.12
@export var cantidad_rayos: int = 2

# Transparencia general — 1.0 = opaco, 0.0 = invisible
@export_range(0.0, 1.0) var transparencia: float = 1.0

# Rotación — 0° = vertical, 45° = diagonal, 90° = horizontal
@export_range(0.0, 90.0) var rotacion_min: float = 0.0
@export_range(0.0, 90.0) var rotacion_max: float = 30.0

# Luz ambiental al caer el rayo
@export var luz_energia: float = 1.8
@export var luz_radio: float = 400.0

var _timer: float = 0.0
var _siguiente: float = 0.0

# Material aditivo compartido — hace que las líneas sumen luz en vez de pintarse encima
var _material_aditivo: CanvasItemMaterial


func _ready():
	_siguiente = randf_range(intervalo_min, intervalo_max)
	_material_aditivo = CanvasItemMaterial.new()
	_material_aditivo.blend_mode = CanvasItemMaterial.BLEND_MODE_ADD


func _process(delta):
	_timer += delta
	if _timer >= _siguiente:
		_timer = 0.0
		_siguiente = randf_range(intervalo_min, intervalo_max)
		for i in range(cantidad_rayos):
			_lanzar_rayo()


func _lanzar_rayo():
	var ancho = get_viewport_rect().size.x
	var alto  = get_viewport_rect().size.y

	var angulo_deg = randf_range(rotacion_min, rotacion_max)
	if randf() > 0.5:
		angulo_deg = -angulo_deg
	var angulo_rad = deg_to_rad(angulo_deg)

	var x_inicio = randf_range(50, ancho - 50)
	var inicio   = Vector2(x_inicio, 0)
	var direccion = Vector2(sin(angulo_rad), 1.0).normalized()
	var fin = inicio + direccion * alto * 1.2

	var puntos = _generar_rayo(inicio, fin, 5)

	# Halo exterior muy difuso
	_crear_linea(puntos, Color(color_rayo.r, color_rayo.g, color_rayo.b, 0.08 * transparencia), 18.0)
	# Halo intermedio
	_crear_linea(puntos, Color(color_rayo.r, color_rayo.g, color_rayo.b, 0.2 * transparencia), 7.0)
	# Halo interior
	_crear_linea(puntos, Color(color_rayo.r, color_rayo.g, color_rayo.b, 0.4 * transparencia), 3.0)
	# Línea principal brillante
	_crear_linea(puntos, Color(color_rayo.r, color_rayo.g, color_rayo.b, transparencia), 1.2)
	# Núcleo blanco central
	_crear_linea(puntos, Color(1.0, 1.0, 1.0, 0.9 * transparencia), 0.5)

	_agregar_ramas(puntos)

	# Destello de luz ambiental en el punto de impacto
	_crear_luz(fin)


func _generar_rayo(a: Vector2, b: Vector2, profundidad: int) -> PackedVector2Array:
	if profundidad == 0:
		return PackedVector2Array([a, b])

	var medio         = (a + b) / 2.0
	var perpendicular = (b - a).rotated(PI / 2.0).normalized()
	var desplazamiento = perpendicular * randf_range(-70, 70) * (float(profundidad) / 5.0)
	medio += desplazamiento

	var izq = _generar_rayo(a, medio, profundidad - 1)
	var der = _generar_rayo(medio, b, profundidad - 1)

	var resultado = PackedVector2Array()
	for p in izq:
		resultado.append(p)
	for p in der:
		resultado.append(p)
	return resultado


func _agregar_ramas(puntos: PackedVector2Array):
	var num_ramas = randi_range(2, 4)
	for i in range(num_ramas):
		var idx      = randi_range(puntos.size() / 4, puntos.size() * 3 / 4)
		var origen   = puntos[idx]
		var fin_rama = origen + Vector2(randf_range(-100, 100), randf_range(80, 250))
		var rama     = _generar_rayo(origen, fin_rama, 3)
		_crear_linea(rama, Color(color_rayo.r, color_rayo.g, color_rayo.b, 0.4 * transparencia), 1.0)
		_crear_linea(rama, Color(1.0, 1.0, 1.0, 0.6 * transparencia), 0.4)


func _crear_linea(puntos: PackedVector2Array, color: Color, grosor: float):
	var linea = Line2D.new()
	linea.points        = puntos
	linea.default_color = color
	linea.width         = grosor
	linea.antialiased   = true
	linea.material      = _material_aditivo
	add_child(linea)
	get_tree().create_timer(duracion_flash).timeout.connect(linea.queue_free)


func _crear_luz(posicion: Vector2):
	var luz = PointLight2D.new()
	luz.position       = posicion
	luz.color          = color_rayo
	luz.energy         = luz_energia
	luz.texture_scale  = luz_radio / 64.0
	luz.shadow_enabled = false

	# Textura gradiente para la luz
	var grad = Gradient.new()
	grad.set_color(0, Color(1, 1, 1, 1))
	grad.set_color(1, Color(0, 0, 0, 0))
	var tex = GradientTexture2D.new()
	tex.gradient  = grad
	tex.fill      = GradientTexture2D.FILL_RADIAL
	tex.fill_from = Vector2(0.5, 0.5)
	tex.fill_to   = Vector2(1.0, 0.5)
	luz.texture   = tex

	add_child(luz)

	# Fade out de la luz con tween
	var tween = create_tween()
	tween.tween_property(luz, "energy", 0.0, duracion_flash * 3.0)
	tween.tween_callback(luz.queue_free)

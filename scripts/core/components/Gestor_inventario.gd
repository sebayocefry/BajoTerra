extends Node
class_name Gestor_inventario

@export var limite_inventario : int = 5
@export var listaObjetos : Array[Objeto] = []
var indice_objeto_seleccionado: int = 0


func _ready():
	# Preserva los objetos iniciales configurados en el inspector
	var items_iniciales = listaObjetos.duplicate()
	listaObjetos.clear()
	listaObjetos.resize(limite_inventario)
	listaObjetos.fill(null)

	for i in range(items_iniciales.size()):
		if i < limite_inventario and items_iniciales[i] != null:
			listaObjetos[i] = items_iniciales[i]

	# Notificar al inventario visual el estado inicial
	await get_tree().process_frame
	Eventos.inventario_completo_actualizado.emit(listaObjetos)


func recibir_objeto(nuevo_objeto: Objeto) -> bool:
	for i in range(listaObjetos.size()):
		if listaObjetos[i] == null:
			listaObjetos[i] = nuevo_objeto
			if i == indice_objeto_seleccionado:
				actualizar_ui_objeto()
			Eventos.inventario_completo_actualizado.emit(listaObjetos)
			return true

	print("Inventario lleno.")
	return false


func ciclar_objeto():
	if listaObjetos.is_empty():
		return

	indice_objeto_seleccionado += 1
	if indice_objeto_seleccionado >= limite_inventario:
		indice_objeto_seleccionado = 0

	actualizar_ui_objeto()


func actualizar_ui_objeto():
	var objeto_actual = listaObjetos[indice_objeto_seleccionado]
	if objeto_actual != null:
		Eventos.consumible_equipado_cambiado.emit(objeto_actual.icono)
	else:
		Eventos.consumible_equipado_cambiado.emit(null)


func usar_objeto_seleccionado():
	var objeto_actual = listaObjetos[indice_objeto_seleccionado]

	if objeto_actual != null:
		objeto_actual.usar(owner as Player)

		if objeto_actual is Consumible:
			listaObjetos[indice_objeto_seleccionado] = null
			print("El objeto se usó y se eliminó.")
			actualizar_ui_objeto()
			Eventos.inventario_completo_actualizado.emit(listaObjetos)
	else:
		print("La mochila está vacía en ese espacio.")

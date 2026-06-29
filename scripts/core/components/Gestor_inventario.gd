extends Node
class_name Gestor_inventario

@export var limite_inventario : int = 5
@export var listaObjetos : Array[Objeto] = []

var indice_qa_1: int = 0
var indice_qa_2: int = -1
var qa_activo: int = 1


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
			
			# Autoequipar si hay espacio en acceso rapido
			if indice_qa_1 == -1:
				indice_qa_1 = i
			elif indice_qa_2 == -1:
				indice_qa_2 = i
				
			actualizar_ui_objeto()
			Eventos.inventario_completo_actualizado.emit(listaObjetos)
			return true

	print("Inventario lleno.")
	return false


func ciclar_objeto():
	qa_activo = 2 if qa_activo == 1 else 1
	actualizar_ui_objeto()


func actualizar_ui_objeto():
	var obj1 = listaObjetos[indice_qa_1] if indice_qa_1 >= 0 and indice_qa_1 < listaObjetos.size() else null
	var obj2 = listaObjetos[indice_qa_2] if indice_qa_2 >= 0 and indice_qa_2 < listaObjetos.size() else null
	
	var icono1 = obj1.icono if obj1 else null
	var icono2 = obj2.icono if obj2 else null
	
	Eventos.consumible_equipado_cambiado.emit(icono1, icono2, qa_activo)


func usar_objeto_seleccionado():
	var index = indice_qa_1 if qa_activo == 1 else indice_qa_2
	
	if index < 0 or index >= listaObjetos.size():
		print("No hay objeto en este acceso rapido.")
		return
		
	var objeto_actual = listaObjetos[index]

	if objeto_actual != null:
		objeto_actual.usar(owner as Player)

		if objeto_actual.get_class() == "Consumible" or objeto_actual is Consumible:
			listaObjetos[index] = null
			if indice_qa_1 == index: indice_qa_1 = -1
			if indice_qa_2 == index: indice_qa_2 = -1
			print("El objeto se usó y se eliminó.")
			actualizar_ui_objeto()
			Eventos.inventario_completo_actualizado.emit(listaObjetos)
	else:
		print("La mochila está vacía en ese espacio.")

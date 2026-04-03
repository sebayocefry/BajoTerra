#lo usamos porque esto no un characterbody ni nodo con cordenadas
extends Resource
class_name Objeto

# Atributos básicos que TODOS los objetos en BajoTerra tendrán
#luego se sobreescribe el nombre de cada objeto, y a la vez nos sirve de debugger
@export var nombre: String = "Objeto Desconocido"
@export_multiline var descripcion: String = ""
@export var icono: Texture2D # La imagen que se mostrará en la UI del inventario
@export var precio_oro: int = 0

func usar(jugador: CharacterBody2D) -> void:
	# Como esta es la clase padre (abstracta), aquí no hace nada.
	# Sus hijos (Consumible, Arma, etc.) reescribirán esta función
	# para hacer lo que les corresponda.
	pass

extends Area2D
class_name NPCDialogo

@export var dialogo: DialogueResource
@export var inicio_dialogo: String = "start"
@export var activar_automaticamente: bool = false

var hablando: bool = false
var ya_hablo: bool = false


func _ready() -> void:
	body_entered.connect(_on_body_entered)

	if activar_automaticamente == true:
		await get_tree().process_frame
		await get_tree().process_frame

		var cuerpos = get_overlapping_bodies()

		for cuerpo in cuerpos:
			if cuerpo is Player:
				iniciar_conversacion()
				return


func iniciar_conversacion() -> void:
	if hablando == true:
		return

	if ya_hablo == true:
		return

	if dialogo == null:
		push_error("Falta asignar el archivo .dialogue en el NPC: " + name)
		return

	hablando = true
	ya_hablo = true

	DialogueManager.show_dialogue_balloon(dialogo, inicio_dialogo)


func _on_body_entered(body: Node2D) -> void:
	if activar_automaticamente == false:
		return

	if body is Player:
		iniciar_conversacion()

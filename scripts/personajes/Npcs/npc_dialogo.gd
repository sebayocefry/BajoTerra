extends Area2D
class_name NPCDialogo

# Nombre exacto de la línea de tiempo que crearon en Dialogic
@export var timeline_name: String = ""

func iniciar_conversacion():
    if timeline_name == "":
        push_error("Este NPC no tiene un timeline de Dialogic asignado.")
        return
        
    Dialogic.start(timeline_name)
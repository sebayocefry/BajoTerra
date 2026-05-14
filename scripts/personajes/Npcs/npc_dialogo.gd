extends Area2D
class_name NPCDialogo

# Nombre exacto de la línea de tiempo que crearon en Dialogic
@export var timeline_name: String = ""

# Esta función es sagrada. El Jugador la invoca automáticamente.
func iniciar_conversacion():
    if timeline_name == "":
        push_error("Este NPC no tiene un timeline de Dialogic asignado.")
        return
    #laura conecta aqui esto despues con el autoload     
   # Dialogic.start(timeline_name)
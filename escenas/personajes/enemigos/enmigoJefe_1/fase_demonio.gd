extends EstadoJefe

@export var prob_ataque_basico : int = 70
@export var prob_invocar : int = 30

func entrar():
	print("Entré al estado FaseDemonio")

	var ataque_elegido = elegir_ataque()

	print("FaseDemonio eligió: ", ataque_elegido)

	transicion.emit(ataque_elegido)

func elegir_ataque() -> String:
	var total = prob_ataque_basico + prob_invocar
	var numero = randi_range(1, total)

	if numero <= prob_ataque_basico:
		return "AtaqueBasicoDemonio"
	else:
		return "InvocarEnemigos"

func actualizar_fisica(_delta):
	pass

func salir():
	print("Salí del estado FaseDemonio")

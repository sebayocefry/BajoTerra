extends EstadoJefe

func entrar():
	print("Entré al estado FaseDemonio")
	print("FaseDemonio elige ataque básico")

	transicion.emit("AtaqueBasicoDemonio")

func actualizar_fisica(_delta):
	pass

func salir():
	print("Salí del estado FaseDemonio")

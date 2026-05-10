extends Node

# Usamos 'user://' porque es la carpeta segura del sistema operativo para guardar datos (AppData en Windows, ~/.local en Linux)
const RUTA_GUARDADO = "user://bajoterra_save.json"

func guardar_partida():
    #  Le pedimos a DatosJugador su estado actual
    var datos = DatosJugador.obtener_datos_diccionario()
    
    #  Convertimos el diccionario a un string JSON
    var json_string = JSON.stringify(datos, "\t") 
    
    #  Escribimos en el disco
    var archivo = FileAccess.open(RUTA_GUARDADO, FileAccess.WRITE)
    if archivo:
        archivo.store_string(json_string)
        archivo.close()
        print("Partida guardada con exito en: ", RUTA_GUARDADO)
    else:
        push_error("Error de I/O: No se pudo escribir el archivo de guardado.")

func cargar_partida() -> bool:
    if not FileAccess.file_exists(RUTA_GUARDADO):
        print("No hay archivo de guardado previo.")
        return false
        
    var archivo = FileAccess.open(RUTA_GUARDADO, FileAccess.READ)
    var json_string = archivo.get_as_text()
    archivo.close()
    
  
    var json = JSON.new()
    var error = json.parse(json_string)
    if error == OK:
        var datos_recuperados = json.data
      
        DatosJugador.cargar_datos_diccionario(datos_recuperados)
        print("Partida cargada con exito.")
        return true
    else:
        push_error("Error de Corrupción: El archivo JSON está dañado.")
        return false
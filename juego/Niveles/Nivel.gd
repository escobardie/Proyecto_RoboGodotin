#Nivel.gd
class_name Nivel
tool
extends Node

## ATRIBUTOS EXPORT
export var numero_nivel:int = 0
export(String, FILE, "*.tscn") var proximo_nivel= ""

## METODOS
func _ready() -> void:
	yield(get_tree().create_timer(4.0), "timeout")
	actualizar_datos()


#utilizamos esto para crear alertas propias(no olvida de colocar el "tool" al inicio del script
func _get_configuration_warning() -> String:
	if numero_nivel == 0 or proximo_nivel == "":
		return "CHEQUEAR VALORES DEL NIVEL"
	
	return ""

func actualizar_datos() ->void:
	#Retorna la ruta en la que se encuentra la
	#escena que tiene adherido el script, en este caso será 
	#la ruta res://juego/niveles/NivelTest.tscn
	DatosJuego.nivel_actual = get_tree().current_scene.filename
	DatosJuego.num_nivel_actual = numero_nivel
	DatosJuego.nivel_proximo = proximo_nivel

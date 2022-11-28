#Nivel.gd
class_name Nivel
tool
extends Node

## ATRIBUTOS EXPORT
export var numero_nivel:int = 0
export(String, FILE, "*.tscn") var proximo_nivel= ""
#export(String, FILE, "*.tscn") var menu_game_over = "res://juego/Menus/MenuFinalCreditos.tscn"

onready var sfx_ambiente: AudioStreamPlayer = $Ambiente

## METODOS
func _ready() -> void:
	sfx_ambiente.play()
# warning-ignore:return_value_discarded
	Eventos.connect("game_over",self, "_on_game_over")
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
	DatosJuego.nivel_actual = get_tree().current_scene.filename
	DatosJuego.num_nivel_actual = numero_nivel
	DatosJuego.nivel_proximo = proximo_nivel

func _on_game_over() ->void:
	print("entro al game over")
	#get_tree().reload_current_scene()
	#get_tree().change_scene(menu_game_over)
	get_tree().quit()



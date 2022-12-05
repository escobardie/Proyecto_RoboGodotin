#Nivel.gd
class_name Nivel
tool
extends Node

## ATRIBUTOS EXPORT
export var numero_nivel:int = 0
export(String, FILE, "*.tscn") var proximo_nivel= ""
export(String, FILE, "*.tscn") var menu_game_over = "res://juego/Menus/MenuGamerOver.tscn"

onready var sfx_ambiente: AudioStreamPlayer = $Ambiente

#var escena_precargada: Node = null
#var cargar: GuardarCargar = GuardarCargar.new()

## METODOS
func _ready() -> void:
	sfx_ambiente.play()
	Eventos.connect("game_over",self, "_on_game_over")
	yield(get_tree().create_timer(0.4), "timeout")
	actualizar_datos()

func _process(_delta: float) -> void:
	pass

func _unhandled_input(_event: InputEvent) -> void:
	var cargar: GuardarCargar = GuardarCargar.new()
	cargar.guardar_datos_juegos()

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
	get_tree().current_scene.queue_free()
	get_tree().current_scene = null
	get_tree().change_scene(menu_game_over)
	#get_tree().quit()


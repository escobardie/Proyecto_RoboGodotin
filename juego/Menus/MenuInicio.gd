#MenuInicio.gd
tool
extends Control

## ATRIBUTOS EXPORT
export(String, FILE, "*.tscn") var menu_ajustes = ""
export(String, FILE, "*.tscn") var nivel_inicial = "" 
export(String, FILE, "*.tscn") var pantalla_carga = ""




onready var musica_menu: AudioStreamPlayer = $Musica


## METODOS
func _ready() -> void:
	###################
	var directory = Directory.new()
	#consulta si exite el archivo donde quedo guardado el juego
	if directory.file_exists("res://guardado/datos_juego.tres"):
		$VBoxContainer/BotonCargar.set_deferred("disabled", false)
	###################
	musica_menu.play()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _get_configuration_warning() -> String:
	if menu_ajustes == "":
		return "CHEQUEAR RUTAS MENU AJUSTES"

	if nivel_inicial == "":
		return "CHEQUEAR RUTAS NIVEL INICIAL"
	
	if pantalla_carga == "":
		return "CHEQUEAR RUTAS PANTALLA CARGA"
	
	return ""



## SEÑALES INTERNAS
func _on_BotonOpciones_pressed() -> void:
	$AudioStreamPlayer.play()
	get_tree().change_scene(menu_ajustes)

func _on_BotonNuevo_pressed() -> void:
	DatosJuego.nivel_actual = nivel_inicial
	get_tree().change_scene(pantalla_carga)

func _on_BotonSalir_pressed() -> void:
	get_tree().quit()


func _on_BotonCargar_pressed() -> void:
	var cargar: GuardarCargar = GuardarCargar.new()
	cargar.cargar_datos_juego()
	get_tree().change_scene(pantalla_carga)
	

#MenuPresentacion.gd
tool
extends Control


## ATRIBUTOS EXPORT
export(String, FILE, "*.tscn") var menu_inicial = ""

## METODOS
func _ready() -> void:
	var cargar: GuardarCargar = GuardarCargar.new()
	cargar.cargar_datos_configuracion()


## METODOS CUSTOM
func _get_configuration_warning() -> String:
	if menu_inicial == "":
		return "NO HAY MENU INICIAL ASIGNADO"
	
	return ""

func cargar_menu() -> void:
	get_tree().change_scene(menu_inicial)


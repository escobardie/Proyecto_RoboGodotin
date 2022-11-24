#MenuInicio.gd
tool
extends Control

## ATRIBUTOS EXPORT
export(String, FILE, "*.tscn") var menu_ajustes = ""

## METODOS
func _get_configuration_warning() -> String:
	if menu_ajustes == "":
		return "CHEQUEAR RUTAS"
	
	return ""

## SEÑALES INTERNAS
func _on_BotonOpciones_pressed() -> void:
	$AudioStreamPlayer.play()
	get_tree().change_scene(menu_ajustes)


func _on_BotonSalir_pressed() -> void:
	get_tree().quit()

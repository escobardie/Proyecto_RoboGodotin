#Portal.gd
class_name PortalNivel
extends Area

##ATRIBUTOS EXPORT
export(String, FILE, "*.tscn") var proximo_nivel = ""

## METODOS
func _ready() -> void:
	pass # Replace with function body.


## SEÑALES INTERNAS
func _on_body_entered(body: Node) -> void:
	if body is Godotin:
# warning-ignore:return_value_discarded
		get_tree().change_scene(proximo_nivel)

#MenuIntermedio.gd
extends Control

## ATRIBUTOS EXPORT
onready var titulo:Label = $Titulo
onready var puntos:Label = $Puntos


## METODOS
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	titulo.text = "Nivel {num} \n COMPLETO".format({"num": DatosJuego.num_nivel_actual})
	puntos.text = "{puntos} \n Puntos Totales".format({"puntos": DatosJuego.generar_puntaje()})

## SEÑALES INTERNAS
func _on_BotonNivel_pressed() -> void:
	get_tree().change_scene(DatosJuego.nivel_proximo)

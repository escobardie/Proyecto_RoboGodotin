#MonedaDorada.gd
class_name Moneda
extends Area

## METODOS
func _ready() -> void:
	pass # Replace with function body.

## SEÑALES INTERNAS
func _on_body_entered(_body: Node) -> void:
	DatosJuego.sumar_monedas()
	$Colisionador.set_deferred("disabled", true)
	$AnimationPlayer.play("consumida")

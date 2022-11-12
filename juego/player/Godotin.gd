# Godotin.gd
class_name Godotin
extends KinematicBody

## ATRIBUTOS CONST
const direccion_arriba: Vector3 = Vector3.UP

## ATRIBUTOS EXPORT
export var velocidad_max: Vector2 = Vector2(10.0, 60.0)
export var gravedad:float = 9.8
export var impulso:float = 50.0
export var fuerza_salto:float = 18.0

## ATRIBUTOS ONREDY
onready var brazo_camara:SpringArm = $BrazoCamara

## ATRIBUTOS
var movimiento: Vector3 = Vector3.ZERO
var salto_interrumpido: bool = false
var saltando:bool = false



## METODOS
func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	brazo_camara.translation = translation

func _physics_process(delta: float) -> void:
	movimiento_vertical()
	movimiento = move_and_slide(movimiento, direccion_arriba)



## METODOS CUSTOM
func movimiento_vertical() -> void:
	#si el personaje no está tocando el suelo entonces
	#vamos a restar a su movimiento en el sentido Y el valor de la gravedad
	if not is_on_floor():
		movimiento.y -= gravedad
		#limitamos la velocidad en la caida
		movimiento.y = clamp(movimiento.y, -velocidad_max.y, impulso)
		#se interrumpe el salto cuando soltamos la tecla
		if Input.is_action_just_released("saltar"):
			salto_interrumpido = true
	else:
		#al ya no estar tocando el suelo..
		saltando = false
	
	#cuando estoy en el suelo y presiono la tecla de saltar en el primer instante
	var inicio_salto:bool = is_on_floor() and Input.is_action_just_pressed("saltar")
	
	if inicio_salto:
		saltando = true
		salto_interrumpido = false
	
	if movimiento.y >= velocidad_max.y:
		salto_interrumpido = true
	
	#Vamos a decir que si presione la tecla saltar y además estoy saltando
	# y el salto no está interrumpido entonces que me sume a mi 
	#movimiento en Y el valor de la fuerza_salto
	if Input.is_action_pressed("saltar") and saltando and not salto_interrumpido:
		movimiento.y += fuerza_salto
		


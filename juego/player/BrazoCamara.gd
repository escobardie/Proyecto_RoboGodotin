#BrazoCamara.gd
extends SpringArm

## ATRIBUTOS EXPORT
export var velocidad_mov_camara:Vector2 = Vector2(0.10, 0.10)
export var rango_rotacion_camara_x:Vector2 = Vector2(-90.0, 30.0)
export var rango_rotacion_camara_y:Vector2 = Vector2(0.0, 360.0)
export var camara_x_invertida: bool = false
export var camara_y_invertida: bool = false

## ATRIBUTOS
var c:= 0


## METODOS
func _ready() -> void:
	#evitamos que se modifiquen sus propiedades de escala, rotación y traslación
	set_as_toplevel(true)
	###############
	###############
	#controlamos la rotacion de la camara conrespecto al movimiento del mouse
	velocidad_mov_camara *= chequear_camara_invertida()
	
	#evitamos que el mouse salga de la pantalla del juego
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(evento: InputEvent) -> void:
	#c += 1
	if evento is InputEventMouseMotion:
		#MOVIMIENTO ALREDEDOR DE X (ARRIBA / ABAJO)
		rotation_degrees.x += evento.relative.y * velocidad_mov_camara.y
		rotation_degrees.x = clamp(
			rotation_degrees.x,
			rango_rotacion_camara_x.x,
			rango_rotacion_camara_x.y
		)
		
		#MOVIMIENTO ALREDEDOR DE Y (DERECHA / INZQUIERDA)
		rotation_degrees.y += evento.relative.x * velocidad_mov_camara.x
		rotation_degrees.y = wrapf(
			rotation_degrees.y,
			rango_rotacion_camara_y.x,
			rango_rotacion_camara_y.y
		)
	#SOLO PARA DEBUG (ES TEMPORAL) usamos la tecla de ESCAPE para cerrar la ventan del juego
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()


## METODOS CUSTOM
func chequear_camara_invertida() -> Vector2:
	var vector_camara = Vector2(1, 1)
	if camara_x_invertida:
		vector_camara.x = -1
	if camara_y_invertida:
		vector_camara.y = -1
	
	return vector_camara


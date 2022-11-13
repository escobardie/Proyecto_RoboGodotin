#BrazoCamara.gd
extends SpringArm

## ATRIBUTOS EXPORT
export var velocidad_mov_camara:float = 0.10
export var rango_rotacion_camara_x:Vector2 = Vector2(-90.0, 30.0)
export var rango_rotacion_camara_y:Vector2 = Vector2(0.0, 360.0)

## ATRIBUTOS
var c:= 0


## METODOS
func _ready() -> void:
	#evitamos que se modifiquen sus propiedades de escala, rotación y traslación
	set_as_toplevel(true)
	#evitamos que el mouse salga de la pantalla del juego
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(evento: InputEvent) -> void:
	c += 1
	if evento is InputEventMouseMotion:
		#MOVIMIENTO ALREDEDOR DE X (ARRIBA / ABAJO)
		#esta en negativo para mover al sentido que me favorece
		rotation_degrees.x -= evento.relative.y * velocidad_mov_camara
		rotation_degrees.x = clamp(
			rotation_degrees.x,
			rango_rotacion_camara_x.x,
			rango_rotacion_camara_x.y
		)
		
		#MOVIMIENTO ALREDEDOR DE Y (DERECHA / INZQUIERDA)
		#esta en negativo para mover al sentido que me favorece
		rotation_degrees.y -= evento.relative.x * velocidad_mov_camara
		rotation_degrees.y = wrapf(
			rotation_degrees.y,
			rango_rotacion_camara_y.x,
			rango_rotacion_camara_y.y
		)
	
	
	
	
	#SOLO PARA DEBUG (ES TEMPORAL) usamos la tecla de ESCAPE para cerrar la ventan del juego
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()




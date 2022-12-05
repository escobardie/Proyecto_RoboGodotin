class_name Player_camera
extends Position3D

# Declare member variables here
export var velocidad_mov_camara:=Vector2(0.1,0.1)
export var rango_rotacion_camara_x:=Vector2(-90.0,30.0)
export var rango_rotacion_camara_y:= Vector2(0.0,360.0) 
export var invert_x_axis:=false
export var invert_y_axis:=false
#onready var spring: Position3D = $Position3D
var node_attached_to:Spatial
var sub_node:Spatial

func checkear_invertido()->Vector2:
	var vector:=Vector2(1,1)
	if invert_x_axis:
		vector.x = -1
	if invert_y_axis:
		vector.y = -1
	return vector
func _unhandled_input(evento):
	if evento is InputEventMouseMotion:
		rotation_degrees.y -= evento.relative.x * velocidad_mov_camara.x
		rotation_degrees.y = wrapf(
			rotation_degrees.y,
			rango_rotacion_camara_y.x,
			rango_rotacion_camara_y.y
		)
		rotation_degrees.x -= evento.relative.y * velocidad_mov_camara.y
		rotation_degrees.x = clamp(
			rotation_degrees.x,
			rango_rotacion_camara_x.x,
			rango_rotacion_camara_x.y
		)
	#todo:delete this
	if Input.is_action_pressed("ui_cancel"):
		get_tree().quit()
# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	velocidad_mov_camara*= checkear_invertido()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if node_attached_to!=null && is_instance_valid(node_attached_to):
		global_transform.origin = node_attached_to.global_transform.origin
		sub_node.global_transform = global_transform

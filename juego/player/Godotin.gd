# Godotin.gd
class_name Godotin
extends KinematicBody

## ATRIBUTOS CONST
const direccion_arriba: Vector3 = Vector3.UP

## ENUM
enum {SUELO, AIRE}

## ATRIBUTOS EXPORT
export var velocidad_max: Vector2 = Vector2(10.0, 60.0)
export var gravedad:float = 9.8
export var impulso:float = 50.0
export var fuerza_salto:float = 18.0


## ATRIBUTOS ONREDY
onready var brazo_camara:SpringArm = $Position3D/BrazoCamara#$Position3D/BrazoCamara
onready var armadura:Spatial = $Armadura
onready var arbol_animacion: ArbolAnimacionPlayer = $ArbolAnimacion
onready var linterna: SpotLight = $Linterna

## ATRIBUTOS
var movimiento: Vector3 = Vector3.ZERO
var vector_snap:Vector3 = Vector3.DOWN
var salto_interrumpido: bool = false
var saltando:bool = false
var cayendo:bool = false
var disparado:bool = false


## METODOS
func _ready() -> void:
	#$Spatial/BrazoCamara.translation
	#Eventos.connect("game_over",self, "game_over")
	pass

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("disparar"):
		arbol_animacion.set_mezcla_disparar(1)
		disparado = true
		linterna.light_energy = 15
	elif event.is_action_released("disparar"):
		arbol_animacion.set_mezcla_disparar(0)
		disparado = false
		linterna.light_energy = 0

func _process(_delta: float) -> void:
	#brazo_camara
	#brazo_camara.translation = Vector3(0.0, 2.0, 0.0)
	brazo_camara.translation = translation

func _physics_process(_delta: float) -> void:
	movimiento_horizontal()
	movimiento_vertical()
	movimiento = move_and_slide_with_snap(movimiento, vector_snap, direccion_arriba, true)
	
	#generamos la direccion/orientacion del personaje, con respecto al movimiento
	var direccion_vista_player = Vector2(movimiento.z, movimiento.x)
	if direccion_vista_player.length() > 0:
		#se le pasa la rotacin de la vista del player a la toracion de la armadura
		armadura.rotation.y = direccion_vista_player.angle()
	
	if disparado:
		#se le pasa la rotacin de la armadura a la toracion de la linterna
		linterna.rotation.y = armadura.rotation.y - 3.14159



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
	
	var tocar_suelo:bool = is_on_floor() and vector_snap == Vector3.ZERO
	#cuando estoy en el suelo y presiono la tecla de saltar en el primer instante
	var inicio_salto:bool = is_on_floor() and Input.is_action_just_pressed("saltar")

	
	if inicio_salto:
		arbol_animacion.set_transicion_suelo_aire(AIRE)
		arbol_animacion.set_mezcla_saltar_caer(0)
		#“Mientras el vector snap esté en contacto con el suelo,
		#el cuerpo permanecerá unido a la superficie
		vector_snap = Vector3.ZERO
		saltando = true
		salto_interrumpido = false
		cayendo = false
	elif tocar_suelo:
		arbol_animacion.set_transicion_suelo_aire(SUELO)
		vector_snap = Vector3.DOWN
	
	
	if movimiento.y >= velocidad_max.y:
		salto_interrumpido = true
	
	#Vamos a decir que si presione la tecla saltar y además estoy saltando
	# y el salto no está interrumpido entonces que me sume a mi 
	#movimiento en Y el valor de la fuerza_salto
	if Input.is_action_pressed("saltar") and saltando and not salto_interrumpido:
		movimiento.y += fuerza_salto
	
	if movimiento.y <= 0 and not cayendo:
		cayendo = true
		for i in range(1, 11, 1):
			arbol_animacion.set_mezcla_saltar_caer(i * 0.1)

func movimiento_horizontal() -> void:
	movimiento.x = tomar_direccion().x * velocidad_max.x
	movimiento.z = tomar_direccion().z * velocidad_max.x

func tomar_direccion() -> Vector3:
	var direccion: Vector3 = Vector3.ZERO
	direccion.x = Input.get_action_strength("mov_der") - Input.get_action_strength("mov_izq")
	direccion.z = Input.get_action_strength("mov_atras") - Input.get_action_strength("mov_adelante")
	arbol_animacion.set_valor_mezcla_idle_caminar(direccion.length())
	#con esto asignamos el movimiento de la camaras con factor para mover al personaje
	direccion = direccion.rotated(Vector3.UP, brazo_camara.rotation.y).normalized()
	
	return direccion

func respawn() -> void:
	DatosJuego.restar_vidas()
	if DatosJuego.vidas >0:
		get_tree().reload_current_scene()


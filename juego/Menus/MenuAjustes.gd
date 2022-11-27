#MenuAjustes.gd
extends Control

## ATRIBUTOS EXPORT
export(String, FILE, "*.tscn") var menu_inicial = ""

## ATRIBUTOS ONREADY
onready var musica_menu: AudioStreamPlayer = $Musica
onready var boton_pantalla_completa: CheckBox = $ContenedorTabulador/AudioVideo/PanelPrincipal/VBoxContainer/PantallaCompleta
onready var opcion_resolucion: OptionButton = $ContenedorTabulador/AudioVideo/PanelPrincipal/VBoxContainer/Resolucion/OpcionResolucion
onready var resoluciones: Dictionary ={
	"640 x 480": Vector2(640, 480),
	"960 x 640": Vector2(960, 640), #resolcuin por defecto
	"1280 x 720": Vector2(1280, 720),
	"1360 x 768": Vector2(1360, 768),
	"1600 x 900": Vector2(1600, 900),
	"1920 x 1080": Vector2(1920, 1080)
}
onready var bus_indices := {
	"Master": AudioServer.get_bus_index("Master"),
	"Musica": AudioServer.get_bus_index("Musica"),
	"SFX": AudioServer.get_bus_index("SFX")
}
onready var bus_etiquetas := {
	"Master": $ContenedorTabulador/AudioVideo/PanelPrincipal/VBoxContainer/VolumenGeneral/NivelVolumen,
	"Musica": $ContenedorTabulador/AudioVideo/PanelPrincipal/VBoxContainer/VolumenMusica/NivelVolumen,
	"SFX": $ContenedorTabulador/AudioVideo/PanelPrincipal/VBoxContainer/VolumenSFX/NivelVolumen
}

## METODOS
func _ready() -> void:
	musica_menu.play()
	#OS es una clase que contiene funciones del sistema operativo y window_fullscreen
	boton_pantalla_completa.set_pressed(OS.window_fullscreen)
	cargar_resoluciones()
	chequear_resolucion_actual()
	cargar_volumen_bus()


## METODOS CUSTOM
func cargar_resoluciones() -> void:
	for resolucion in resoluciones.keys():
		opcion_resolucion.add_item(resolucion)

func centrar_pantalla(resolucion: Vector2) -> void:
	var tamanio_pantalla := OS.get_screen_size()
	print(tamanio_pantalla)
	print(resolucion)
	OS.set_window_position(tamanio_pantalla * 0.5 - resolucion * 0.5)

func chequear_resolucion_actual() -> void:
	var texto_resolucion_actual = String(OS.window_size.x) + " x " + String(OS.window_size.y)
	
# warning-ignore:unused_variable
	var indice_resolucion_selecionada: int = 0
	
	for i in range(opcion_resolucion.get_item_count()):
		if texto_resolucion_actual == opcion_resolucion.get_item_text(i):
			opcion_resolucion.select(i)
			indice_resolucion_selecionada = i

func cargar_volumen_bus() -> void:
	for bus_indice in bus_indices.values():
		var volumen_actual: float = AudioServer.get_bus_volume_db(bus_indice)
		var nombre_bus: String = AudioServer.get_bus_name(bus_indice)
		var texto_volumen: String = "%01d" % (volumen_actual + 50)
		

		bus_etiquetas[nombre_bus].text = texto_volumen
		

func cambiar_volumen(indice_bus: int, subir:bool) -> void:
	var volumen_anterior:float = AudioServer.get_bus_volume_db(indice_bus)
	var nuevo_volumen: float

	if subir:
		nuevo_volumen = volumen_anterior - 1
	else:
		nuevo_volumen = volumen_anterior + 1
	
	nuevo_volumen = clamp(nuevo_volumen, -50, 150)
	AudioServer.set_bus_volume_db(indice_bus, nuevo_volumen)
	cargar_volumen_bus()


## SEÑALES INTERNAS
func _on_BotonRegreso_pressed() -> void:
	var guardar: GuardarCargar = GuardarCargar.new()
	guardar.guardar_datos_configuracion()
# warning-ignore:return_value_discarded
	get_tree().change_scene(menu_inicial)


func _on_PantallaCompleta_toggled(button_pressed: bool) -> void:
	OS.window_fullscreen = button_pressed


func _on_OpcionResolucion_item_selected(indice: int) -> void:
	var nueva_resolucion: Vector2 = resoluciones[opcion_resolucion.get_item_text(indice)]
	OS.window_size = nueva_resolucion
	centrar_pantalla(OS.window_size)


func _on_General_BajarVolum_pressed() -> void:
	cambiar_volumen(bus_indices.Master,true)


func _on_General_SubirVolum_pressed() -> void:
	cambiar_volumen(bus_indices.Master,false)


func _on_Musica_BajarVolum_pressed() -> void:
	cambiar_volumen(bus_indices.Musica,true)


func _on_Musica_SubirVolum_pressed() -> void:
	cambiar_volumen(bus_indices.Musica,false)


func _on_SFX_BajarVolum_pressed() -> void:
	cambiar_volumen(bus_indices.SFX,true)


func _on_SFX_SubirVolum_pressed() -> void:
	cambiar_volumen(bus_indices.SFX,false)

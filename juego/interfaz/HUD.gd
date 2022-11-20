extends Control

## ATRIBUTOS EXPORT
#contenedor vidas tiene un texto (donde figura las vidas), que se llama cantidad
onready var etiqueta_vidas = $ContenedorVidas/Cantidad
#variables para las etiqueta de las monedas
onready var etiqueta_moneda_oro = $ContenedorMonedasOro/Cantidad
onready var etiqueta_nombre = $ContenedorNombre/Cantidad


## METODOS
func _ready():
	Eventos.connect("actualizar_hub", self, "actualizar_hud")
	actualizar_hud()

## METODOS CUSTOM
func actualizar_hud():
	#de la etiqueta, queremos el texto. ese texto son los datos de vida dentro del sript
	#con los comandos   "%s" %  convertimos una cadena de numero a string
	etiqueta_vidas.text = "%s" % DatosJuego.vidas
	etiqueta_moneda_oro.text = "%s" % DatosJuego.moneda_oro
	etiqueta_nombre.text = "Nivel: {num}".format({"num": DatosJuego.num_nivel_actual})
	#etiqueta_nombre.text = "nivel: %s" % DatosJuego.numero_nivel



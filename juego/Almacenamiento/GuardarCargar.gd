#GuardarCargar.gd
class_name GuardarCargar
extends Node

## ENUM
enum {JUEGO, CONFIG}

## GUARDAR DATOS
func guardar_datos_configuracion() -> int:
	if not OS.get_name() in DatosConfiguracion.OS_ADMITIDOS_GUARDAR:
		return -1
	
	var ruta: String = seleccionar_ruta(CONFIG)
	
	var datos: DatosAjustesGuardado = DatosAjustesGuardado.new()
	datos.pantalla_completa = OS.window_fullscreen
	datos.pantalla_resolucion = OS.window_size
	datos.volumen_buses = {
		"master": AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master")),
		"musica": AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Musica")),
		"sfx": AudioServer.get_bus_volume_db(AudioServer.get_bus_index("SFX"))
	}
	
	
	var resultado: int = ResourceSaver.save(ruta, datos)
	
	return resultado

func guardar_datos_juegos() -> int:
	if not OS.get_name() in DatosConfiguracion.OS_ADMITIDOS_GUARDAR:
		return -1
	
	var ruta: String = seleccionar_ruta(JUEGO)
	
	var datos: DatosUsuarioGuardado = DatosUsuarioGuardado.new()
	datos.vidas = DatosJuego.vidas
	datos.moneda_oro = DatosJuego.moneda_oro
	datos.nivel_actual = DatosJuego.nivel_actual
	datos.num_nivel_actual = DatosJuego.num_nivel_actual
	datos.nivel_proximo = DatosJuego.nivel_proximo
	########
	#verdadero porque hay datos guardados
	datos.juego_guardado = true
	#datos.juego_guardado = DatosJuego.juego_guardado
	########
	
	var resultado: int = ResourceSaver.save(ruta, datos)
	
	return resultado



## CARGAR DATOS
func cargar_datos_configuracion() -> void:
	var ruta: String = seleccionar_ruta(CONFIG)
	var dir: Directory = Directory.new()
	#si no existe, se greara uno:
	if not dir.file_exists(ruta):
		guardar_datos_configuracion()
	
	
	
	######
	#if not dir.file_exists(rutaJ):
	#	guardar_datos_juegos()
	######
	
	else:
		var datos: Resource = load(ruta)
		OS.window_fullscreen = datos.pantalla_completa
		OS.window_size = datos.pantalla_resolucion
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"),datos.volumen_buses.master)
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Musica"),datos.volumen_buses.musica)
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"),datos.volumen_buses.sfx)
		
		var tamanio_pantalla := OS.get_screen_size()
		OS.set_window_position((tamanio_pantalla - datos.pantalla_resolucion) * 0.5)

func cargar_datos_juego() -> void:
	######
	var rutaJ:  String = seleccionar_ruta(JUEGO)
	var dir: Directory = Directory.new()
	#si no existe, se greara uno:
	if not dir.file_exists(rutaJ):
		guardar_datos_juegos()
	######
	
	var ruta: String = seleccionar_ruta(JUEGO)
	var datos: Resource = load(ruta)
	
	DatosJuego.vidas = datos.vidas
	DatosJuego.moneda_oro = datos.moneda_oro
	DatosJuego.nivel_actual = datos.nivel_actual
	DatosJuego.num_nivel_actual = datos.num_nivel_actual
	DatosJuego.nivel_proximo = datos.nivel_proximo
	DatosJuego.juego_guardado = datos.juego_guardado


## METODOS VARIOS
func seleccionar_ruta(archivo: int) -> String:
	var ruta: String
	
	if OS.is_debug_build():
		ruta = DatosConfiguracion.RUTA_GUARDAR_DEBUG
	else:
		ruta = DatosConfiguracion.RUTA_GUARDAR_RELEASE
	
	chequear_existencia_directorio(ruta)
	
	match archivo:
		JUEGO:
			ruta += DatosConfiguracion.NOMBRE_ARCHIVO_DATOS
		CONFIG:
			ruta += DatosConfiguracion.NOMBRE_ARCHIVO_CONFIG
		_:
			printerr("No existe ese tipo de archivo")
	#ruta += DatosConfiguracion.NOMBRE_ARCHIVO_DATOS + tipo_extencion
	return ruta

func chequear_existencia_directorio(ruta: String) -> void:
	var dir:Directory = Directory.new()
	if not dir.dir_exists(ruta):
		Directory.new().make_dir_recursive(ruta)

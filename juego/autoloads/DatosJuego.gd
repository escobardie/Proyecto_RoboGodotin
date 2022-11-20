#DatosJuego.gd
extends Node

#script con patron singleton, quiere decir que no se vera afectado
#por los efectos de juego
#lo que esta aqui, persiste mas alla del reinicio de la escena


#VARIABLES PARA EL HUD
var vidas:int = 3
var moneda_oro:int = 0
var puntaje_monedas:int = 0
#esta variable (que me la cargo la escena DE NIVEL) la estara usando menu game over 
var nivel_actual:String = ""
var num_nivel_actual:int = 0
var nivel_proximo:String = ""


## METODOS CUSTOM
#metodo para restablecer los valores, esto pasara cuando estemos en la escena de GAMEOVER
#se ejecutara ni bien perdamos (definida en menugameover)
func reset():
	vidas = 3
	moneda_oro = 0
	puntaje_monedas = 0


#metodo para calcular los puntos al momento de ganar la partida
func generar_puntaje():
	var valor_oro = moneda_oro * 10
	puntaje_monedas = valor_oro
	return puntaje_monedas


func restar_vidas():
	vidas -= 1
	if vidas == 0:
		#emitimos la señal
		Eventos.emit_signal("game_over")
	Eventos.emit_signal("actualizar_hub")


func sumar_monedas():
	moneda_oro += 1
	Eventos.emit_signal("actualizar_hub")

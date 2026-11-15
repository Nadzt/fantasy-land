class_name GameManagerAutoLoad
extends Node


signal puntos_cambiados
signal jefe_derrotado
signal juego_terminado
signal enemigos_derrotados

var puntos: int = 0
var cantidad_jefes: int = 2
var cant_jefes_derrotados: int = 0
var cant_enemigos: int = 5 #valor de prueba, modificar despes con la contidad correspondiente

func sumar_puntos(points: int):
	puntos += points
	puntos_cambiados.emit()

func jefe_fue_derrotado() -> void:
	cant_jefes_derrotados += 1
	jefe_derrotado.emit()
	
	if cant_jefes_derrotados >= cantidad_jefes:
		fin_del_juego()

func fin_del_juego() -> void:
	juego_terminado.emit()
	#Aca no sé si debe mostrar algo o es parte de UI

func enemigo_derrotado() -> void:
	cant_enemigos -= 1
	enemigos_derrotados.emit()

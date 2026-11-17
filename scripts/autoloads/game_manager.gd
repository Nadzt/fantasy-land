class_name GameManagerAutoLoad
extends Node


signal puntos_cambiados(puntos_totales: int)
signal jefe_derrotado
signal juego_terminado
signal enemigos_derrotados
signal gema_conseguida(id_gema: String)

var gemas_obtenidas: Array[String] = []
var puntos: int = 10000
var cantidad_jefes: int = 2
var cant_jefes_derrotados: int = 0
var cant_enemigos: int = 5 #valor de prueba, modificar despes con la contidad correspondiente

func sumar_puntos(_points: int):
	puntos += _points
	puntos_cambiados.emit(puntos)

func restar_puntos(_points: int) -> void:
	puntos -= _points
	puntos_cambiados.emit(puntos)

func get_puntos() -> int:
	return puntos

func jefe_fue_derrotado() -> void:
	cant_jefes_derrotados += 1
	jefe_derrotado.emit()
	
	if cant_jefes_derrotados >= cantidad_jefes:
		fin_del_juego()

func fin_del_juego() -> void:
	get_tree().call_deferred("change_scene_to_file", "uid://cojne0qvpfj6d")

func enemigo_derrotado() -> void:
	cant_enemigos -= 1
	enemigos_derrotados.emit()

func registrar_gema(id: String) -> void:

	if not gemas_obtenidas.has(id):
		gemas_obtenidas.append(id)
		gema_conseguida.emit(id)
		
		

func ejecutar_game_over() -> void:
	get_tree().call_deferred("change_scene_to_file", "uid://btosx1igptbbb")

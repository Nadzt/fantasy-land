extends Node

@export var jugador: Node2D

func guardar_partida() -> void:
	var data = SaveData.new()
	data.posicion_jugador = jugador.global_position
	data.puntos = GameManager.puntos
	data.cant_jefes_derrotados = GameManager.cant_jefes_derrotados
	ResourceSaver.save(data, "user://partida.tres")
	


func cargar_partida() -> void:
	if ResourceLoader.exists("user://partida.tres"):
		var data = load("user://partida.tres")
		jugador.global_position = data.posicion_jugador
		GameManager.puntos = data.puntos
		GameManager.puntos_cambiados.emit()
		GameManager.cant_jefes_derrotados = data.cant_jefes_derrotados
		GameManager.jefe_derrotado.emit()

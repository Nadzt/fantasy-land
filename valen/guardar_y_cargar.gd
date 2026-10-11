extends Node

@export var jugador: Node2D

func guardar_partida() -> void:
	var data = SaveData.new()
	data.posicion_jugador = jugador.global_position
	ResourceSaver.save(data, "user://partida.tres")
	


func cargar_partida() -> void:
	if ResourceLoader.exists("user://partida.tres"):
		var data = load("user://partida.tres")
		jugador.global_position = data.player_position

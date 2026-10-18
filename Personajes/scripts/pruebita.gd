extends Node2D

var jugador = preload("res://jugador.tscn")

func _ready() : 

	var instanciaJugador = jugador.instantiate()
	add_child(instanciaJugador)

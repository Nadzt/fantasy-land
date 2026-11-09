extends Node2D

var jugador = preload("res://EscenasP/jugador.tscn")
var ojo = preload("res://EscenasP/ojo_volador.tscn")

func _ready() : 

	var instanciaJugador = jugador.instantiate()
	add_child(instanciaJugador)
	
	var instanciaOjo = ojo.instantiate()
	add_child(instanciaOjo)

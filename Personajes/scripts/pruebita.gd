extends Node2D

var jugador = preload("res://jugador.tscn")
var ojo = preload("res://ojo_volador.tscn")
var esqueleto = preload("res://esqueleto_armado.tscn")

func _ready() : 

	var instanciaJugador = jugador.instantiate()
	add_child(instanciaJugador)
	
	var instanciaOjo = ojo.instantiate()
	add_child(instanciaOjo)
	
	var instanciaEsqueleto = esqueleto.instantiate()
	instanciaEsqueleto.position = Vector2(140, 140)
	add_child(instanciaEsqueleto)

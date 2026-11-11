extends Node2D

var jugador = preload("res://jugador.tscn")
var ojo = preload("res://ojo_volador.tscn")
var esqueletoArmado = preload("res://esqueleto_armado.tscn")
var esqueletoFijo = preload("res://esqueleto_fijo.tscn")
var orco = preload("res://orco.tscn")

func _ready() : 

	var instanciaJugador = jugador.instantiate()
	add_child(instanciaJugador)
	
	var instanciaOjo = ojo.instantiate()
	add_child(instanciaOjo)
	
	var instanciaEsqueleto = esqueletoArmado.instantiate()
	instanciaEsqueleto.position = Vector2(140, 140)
	add_child(instanciaEsqueleto)
	
	var instanciaEsqueletoFijo = esqueletoFijo.instantiate()
	instanciaEsqueletoFijo.position = Vector2(160, 140)
	add_child(instanciaEsqueletoFijo)
	
	var instanciaOrco = orco.instantiate()
	instanciaOrco.position = Vector2(0, 140)
	add_child(instanciaOrco)

extends Node2D

@export var jugador: PackedScene
@export var ojo: PackedScene
@export var esqueletoArmado: PackedScene
@export var esqueletoFijo: PackedScene
@export var orco: PackedScene
@export var jefe: PackedScene

func _ready() : 

	var instanciaJugador = jugador.instantiate()
	add_child(instanciaJugador)
	
	var instanciaOjo = ojo.instantiate()
	add_child(instanciaOjo)
	#
	#var instanciaEsqueleto = esqueletoArmado.instantiate()
	#instanciaEsqueleto.position = Vector2(140, 140)
	#add_child(instanciaEsqueleto)
	#
	#var instanciaEsqueletoFijo = esqueletoFijo.instantiate()
	#instanciaEsqueletoFijo.position = Vector2(160, 140)
	#add_child(instanciaEsqueletoFijo)
	#
	#var instanciaOrco = orco.instantiate()
	#instanciaOrco.position = Vector2(0, 140)
	#add_child(instanciaOrco)
	
	var instanciarJefe = jefe.instantiate()
	instanciarJefe.position = Vector2(180, 140)
	add_child(instanciarJefe)

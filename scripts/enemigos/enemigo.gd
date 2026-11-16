@abstract
class_name Enemigo
extends Personaje

@export var _puntaje: int
var jugador: Jugador = null
var item_drop: PackedScene = preload("uid://sw2f3xj4wdoh")

func _init(e_puntaje:int):
	super(100, 10, 5) #Valores por defecto
	_puntaje = e_puntaje
	
func _ready() -> void:
	add_to_group("Enemigos")
	jugador = get_tree().get_first_node_in_group("Jugador")

@abstract
func atacar() -> void

@abstract
func soltar_item() -> void

func _morir() -> void:
	GameManager.sumar_puntos(_puntaje)
	soltar_item()
	GameManager.enemigo_derrotado()
	await super._morir()

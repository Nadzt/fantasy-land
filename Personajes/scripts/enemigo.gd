@abstract
class_name Enemigo
extends Personaje

@export var _puntaje: int

func _init(e_puntaje:int):
	_puntaje = e_puntaje

@abstract
func atacar() -> void

@abstract
func soltar_item() -> void

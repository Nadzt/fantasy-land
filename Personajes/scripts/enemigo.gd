@abstract
class_name Enemigo
extends Personaje

@export var _puntaje: int

func _init(e_puntaje:int):
	super(100, 10, 5) #Valores por defecto
	_puntaje = e_puntaje

@abstract
func atacar() -> void

@abstract
func soltar_item() -> void

@abstract
class_name Personaje
extends CharacterBody2D

@export var _vida: int
@export var _fuerza: int
@export var _defensa: int
@export var _sprites: SpriteFrames

func _init(p_vida:int, p_fuerza:int, p_defensa:int):
	_vida = p_vida
	_fuerza = p_fuerza
	_defensa = p_defensa

@abstract 
func recibir_dmg(dmg: int) -> void

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta/2

	move_and_slide()

func _morir() -> void:
	queue_free()

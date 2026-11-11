@abstract
class_name Personaje
extends CharacterBody2D

@export var _vida: int
@export var _fuerza: int
@export var _defensa: int

@export var vuela: bool = false

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var _muerto := false

func _init(p_vida:int, p_fuerza:int, p_defensa:int):
	_vida = p_vida
	_fuerza = p_fuerza
	_defensa = p_defensa

func recibir_dmg(dmg: int) -> void:
	if _muerto:
		return
	_vida -= maxi(dmg - _defensa, 0)
	_parpadear_rojo()

	if _vida <= 0:
		_vida = 0
		_morir()

func _parpadear_rojo() -> void:
	var tween := create_tween()
	tween.set_loops(2)
	tween.tween_property(sprite, "modulate", Color.RED, 0.08)
	tween.tween_property(sprite, "modulate", Color.WHITE, 0.08)

func _physics_process(delta: float) -> void:
	_aplicar_gravedad(delta)
	move_and_slide()
 
func _aplicar_gravedad(delta: float) -> void:
	if vuela:
		return
	if not is_on_floor():
		velocity += get_gravity() * delta

func _morir() -> void:
	if _muerto:
		return
	_muerto = true
	
	set_physics_process(false)
	if sprite.sprite_frames and sprite.sprite_frames.has_animation("morir"):
		sprite.play("morir")
		await sprite.animation_finished
	queue_free()
	

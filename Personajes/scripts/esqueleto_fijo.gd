class_name EsqueletoFijo
extends Enemigo

@export var rango_ataque: float = 50.0

var jugador: Jugador = null
#@onready var arma: Node2D = $Arma 

func _init() -> void:
	super(20)
	_vida = 10
	_fuerza = 5
	_defensa = 5
	
func _ready() -> void:
	jugador = get_tree().get_first_node_in_group("Jugador")
	sprite.play("idle")
	
func _physics_process(delta: float) -> void:
	
	super._physics_process(delta)
	
	if jugador and is_instance_valid(jugador):
		if global_position.distance_to(jugador.global_position) <= rango_ataque:
			sprite.flip_h = global_position.direction_to(jugador.global_position).x < 0
			atacar()

func atacar() -> void:
#REVISAR ARMAS DESPUÉS
	#if jugador and global_position.distance_to(jugador.global_position) <= rango_ataque:
		## jugador.recibir_dmg(_fuerza)
		pass

func soltar_item() -> void:
	pass

func _morir() -> void:
	sprite.play("morir")
	await sprite.animation_finished
	soltar_item()
	super._morir()

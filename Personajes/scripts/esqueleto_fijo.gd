class_name EsqueletoFijo
extends EnemigoConArma

@export var rango_ataque: float = 50.0

#@onready var arma: Node2D = $Arma 

func _init() -> void:
	super(20)
	_vida = 10
	_fuerza = 5
	_defensa = 5
	
func _ready() -> void:
	super._ready()
	sprite.play("idle")
	
func _physics_process(delta: float) -> void:
	
	if _muerto:
		return
	super._physics_process(delta)
	
	if jugador and is_instance_valid(jugador):
		if global_position.distance_to(jugador.global_position) <= rango_ataque:
			sprite.flip_h = global_position.direction_to(jugador.global_position).x < 0
			
			if intentar_atacar():
				atacar()

func atacar() -> void:
	print("Uso una maza para atacar")

func soltar_item() -> void:
	print("Suelto la maza")

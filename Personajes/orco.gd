class_name Orco
extends Enemigo

@export var velocidad: float = 70.0
var jugador : Jugador = null

func _init() -> void:
	super(70) 

	_vida = 65
	_fuerza = 10
	_defensa = 5

func _ready() -> void:
	jugador = get_tree().get_first_node_in_group("Jugador")
	sprite.play("correr")

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta / 2

	# Este lo hice hacia la derecha
	velocity.x = velocidad

	move_and_slide()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Jugador:
		atacar()

func atacar() -> void:
	if jugador and is_instance_valid(jugador):
		jugador.recibir_dmg(_fuerza)
		print("¡El orco atacó al jugador e hizo ", _fuerza, " de daño!")

func soltar_item() -> void:
	pass

func _morir() -> void:
	sprite.play("morir")
	await sprite.animation_finished

	soltar_item()
	super._morir()

class_name Jugador
extends Personaje

@export var speed: float = 300.0
@export var jump_velocity: float = -400.0
@export var velocidad_trepado: float = 50.0

var _saltos_hechos: int = 0
var puede_trepar := false
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

#var mano_derecha:Arma
#var mano_izquierda:Arma

func _init():
	super(100, 20, 5)

func _ready() -> void:
	add_to_group("Jugador")
	
func recibir_dmg(dmg: int) -> void:
	super(dmg)
	if not _muerto:
		sprite.play("recibir_ataque")

#func usar_mano_derecha() -> void:
	#if mano_derecha:
		#mano_derecha.usar()
#
#
#func usar_mano_izquierda() -> void:
	#if mano_izquierda:
		#mano_izquierda.usar()
#
#
#func agarrar_arma(arma:Arma) -> void:
#
	#if arma.es_de_dos_manos:
		#mano_derecha = arma
		#mano_izquierda = arma
		#return
#
	#if mano_derecha == null:
		#mano_derecha = arma
	#elif mano_izquierda == null:
		#mano_izquierda = arma

func agarrar_item() -> void:
	pass #después definir la clase Item"

func _physics_process(delta):
	
	if puede_trepar and Input.is_action_pressed("ui_up"):
		trepar()
		return
		
	super._physics_process(delta)

	if is_on_floor():
		sprite.play("idle")

	correr()
	saltar()

	if Input.is_action_just_pressed("ui_accept") and not is_on_floor():
		doble_salto()

func trepar() -> void:
	velocity.x = 0
	velocity.y = -velocidad_trepado
	sprite.play("trepar")
	move_and_slide()

func saltar():
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		_saltos_hechos = 1
		velocity.y = jump_velocity
		sprite.play("salto")
		
func correr():	
	var dire := Input.get_axis("ui_left", "ui_right")
	
	if dire != 0:
		sprite.flip_h = dire < 0 
		
		if Input.is_action_pressed("ui_accept"):
			velocity.x = dire * speed * 2 # corre
			sprite.play("correr")
		else:
			velocity.x = dire * speed     # camina
			sprite.play("caminar")
	else:
		velocity.x = 0

func doble_salto() -> void:
	if not is_on_floor() and _saltos_hechos < 2:
		_saltos_hechos += 1
		velocity.y = jump_velocity
		sprite.play("salto")

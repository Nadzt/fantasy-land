class_name Jugador
extends Personaje

@export var speed: float = 300.0
@export var jump_velocity: float = -400.0

var _saltos_hechos: int = 0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

#var mano_derecha:Arma
#var mano_izquierda:Arma

func _init():
	super(100, 20, 5)

func recibir_dmg(dmg: int) -> void:
	var dmg_final := maxi(dmg - _defensa, 0)
	_vida -= dmg_final
	if _vida <= 0:
		_vida = 0
		_morir()
 
func _morir() -> void:
	queue_free()
	
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
	super._physics_process(delta)
	correr(delta)
	saltar(delta)
	
	if Input.is_action_just_pressed("ui_accept") and not is_on_floor():
		doble_salto()

func trepar() -> void:
	velocity.y = -speed

func saltar(delta):
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		_saltos_hechos = 1
		velocity.y = jump_velocity
		
func correr(delta):	
	var dire := Input.get_axis("ui_left", "ui_right")
	
	# para verificar si mantiene el espacio para correr
	if Input.is_action_pressed("ui_accept"):
		velocity.x = dire * speed * 2  # corre
	else:
		velocity.x = dire * speed      # camina

func doble_salto() -> void:
	if not is_on_floor() and _saltos_hechos < 2:
		_saltos_hechos += 1
		velocity.y = jump_velocity

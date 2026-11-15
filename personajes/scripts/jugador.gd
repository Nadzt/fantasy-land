class_name Jugador
extends Personaje

signal cambio_en_vida

const vida_max:int = 100 #cambiar segun convenga

@export var speed: float = 300.0
@export var jump_velocity: float = -400.0
@export var velocidad_trepado: float = 50.0

var _saltos_hechos: int = 0
var puede_trepar := false

@export_group("armas")
@export var mano_derecha: Mano
@export var mano_izquierda: Mano
@export var slot_adelante: Node2D
@export var slot_atras: Node2D
@export_subgroup("escenas")
@export var escena_arma: PackedScene
@export var escena_drop: PackedScene

@export_subgroup("personaje mira a la izquierda")
@export var mano_izquierda_pos_1: Vector2 = Vector2(1.5, 7)
@export var mano_derecha_pos_1: Vector2 = Vector2(-9.5, 4.5)
@export_subgroup("personaje mira a la derecha")
@export var mano_izquierda_pos_2: Vector2 = Vector2(7, 5)
@export var mano_derecha_pos_2: Vector2 = Vector2(-3, 7)


func _init():
	super(100, 20, 5)

func _ready() -> void:
	add_to_group("Jugador")
	
	cambiar_pos_manos(false)
	if mano_izquierda.arma:
		mano_izquierda.arma.actualizar_pos()
	if mano_derecha.arma:
		mano_derecha.arma.actualizar_pos()

func recibir_dmg(dmg: int) -> void:
	super(dmg)
	if not _muerto:
		sprite.play("recibir_ataque")
		cambio_en_vida.emit()

func usar_mano_derecha() -> void:
	if mano_derecha:
		mano_derecha.usar()

func usar_mano_izquierda() -> void:
	if mano_izquierda:
		mano_izquierda.usar()

func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("usar_mano_der"):
		usar_mano_derecha()
	
	if Input.is_action_just_pressed("usar_mano_izq"):
		usar_mano_izquierda()

func agarrar_arma(res: ArmaResource, es_arma_izquierda: bool) -> void:
	var nueva_arma: ArmaMelee = escena_arma.instantiate()
	nueva_arma.res = res
	
	if es_arma_izquierda:
		for child in mano_izquierda.get_children():
			if child is ArmaMelee:
				drop_arma(child.res)
			child.queue_free()
		mano_izquierda.add_child(nueva_arma)
		mano_izquierda.set_arma(nueva_arma)
		return
	
	if !es_arma_izquierda:
		for child in mano_derecha.get_children():
			if child is ArmaMelee:
				drop_arma(child.res)
			child.queue_free()
		mano_derecha.add_child(nueva_arma)
		mano_derecha.set_arma(nueva_arma)
		return

func drop_arma(res_arma: ArmaResource) -> void:
	var nuevo_drop: Drop = escena_drop.instantiate()
	nuevo_drop.sprite.texture = res_arma.get_sprite()
	nuevo_drop.res = res_arma
	nuevo_drop.global_position = global_position
	get_tree().current_scene.get_node("Drops").add_child(nuevo_drop)

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
		cambiar_pos_manos(dire < 0)
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

## cambia las posiciones de las manos en el characterbody2d
func cambiar_pos_manos(mira_hacia_izquierda: bool) -> void:
	# cambio la posicion de las manos
	mano_izquierda.position = mano_izquierda_pos_1 if mira_hacia_izquierda else mano_izquierda_pos_2
	mano_derecha.position = mano_derecha_pos_1 if mira_hacia_izquierda else mano_derecha_pos_2
	
	# cambio si estan adelante o atras del jugador
	if mira_hacia_izquierda:
		mano_izquierda.reparent(slot_adelante)
		mano_derecha.reparent(slot_atras)
	else:
		mano_izquierda.reparent(slot_atras)
		mano_derecha.reparent(slot_adelante)
	
	# actualizo las posiciones de las armas e
	if mano_izquierda.arma:
		mano_izquierda.arma.actualizar_pos()
		mano_izquierda.arma.invertir_por_direccion(mira_hacia_izquierda)
	if mano_derecha.arma:
		mano_derecha.arma.actualizar_pos()
		mano_derecha.arma.invertir_por_direccion(mira_hacia_izquierda)

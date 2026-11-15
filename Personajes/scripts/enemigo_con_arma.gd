class_name EnemigoConArma
extends Enemigo

@export var tiempo_cooldown: float = 1.5     
var _tiempo_actual_ataque: float = 0.0    

@onready var arma: ArmaMelee


@export_group("armas")
@export var mano_derecha: Mano
@export var mano_izquierda: Mano
@export var slot_adelante: Node2D
@export var slot_atras: Node2D
@export_subgroup("personaje mira a la izquierda")
@export var mano_izquierda_pos_1: Vector2 = Vector2(1.5, 7)
@export var mano_derecha_pos_1: Vector2 = Vector2(-9.5, 4.5)

@export_subgroup("personaje mira a la derecha")
@export var mano_izquierda_pos_2: Vector2 = Vector2(7, 5)
@export var mano_derecha_pos_2: Vector2 = Vector2(-3, 7)

func _ready() -> void:
	super._ready()
	cambiar_pos_manos(false)
	
	if mano_izquierda.arma:
		
		arma = mano_izquierda.arma
		mano_izquierda.arma.actualizar_pos()
	if mano_derecha.arma:
		mano_derecha.arma.actualizar_pos()


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y = get_gravity().y * delta * 10
	if _tiempo_actual_ataque > 0:
		_tiempo_actual_ataque -= delta

func intentar_atacar() -> bool:
	if _tiempo_actual_ataque <= 0 and jugador and is_instance_valid(jugador):
		
		if arma and arma.has_method("usar"):
			arma.usar()
			
		_tiempo_actual_ataque = tiempo_cooldown # acá reinicio el cooldown
		return true
		
	return false

func atacar() -> void:
	intentar_atacar()

func soltar_item() -> void:
	var nuevo_drop: Drop = item_drop.instantiate()
	nuevo_drop.sprite.texture = arma.res.get_sprite()
	nuevo_drop.res = arma.res
	nuevo_drop.global_position = global_position
	get_tree().current_scene.get_node("Drops").add_child(nuevo_drop)

func _morir() -> void:
	mano_derecha.hide()
	mano_izquierda.hide()
	super._morir()

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

func cambiar_arma_principal(mira_hacia_izquierda: bool) -> void:
	if mira_hacia_izquierda:
		arma = mano_derecha.arma
	else:
		arma = mano_izquierda.arma

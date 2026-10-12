class_name ArmaMelee extends Node2D

@export_group("recurso")
@export var res: ArmaResource

@export_group("componentes")
@export var sprite: Sprite2D
@export var pivote: Node2D
@export var container: Node2D
@export var hitbox: CollisionPolygon2D
@export var cooldown_timer: Timer
@export var esperando_timer: Timer

@export_group("animacion de ataque")
enum estado {
	lista,
	atacando,
	esperando,
	volviendo,
	en_cooldown
}
var estado_actual: estado = estado.lista
var angulo_acumulado: float = 0.0


func _ready() -> void:
	sprite.texture = res.get_sprite()
	container.position = res.get_pos_mano()
	_cargar_hitbox()
	
	# ver poligones
	var collision_polygon_2d: CollisionPolygon2D = $Pivote/Container/Area2D/CollisionPolygon2D
	for x in collision_polygon_2d.polygon:
		print(x)

func usar() -> void:
	print("usando arma")
	empezar_ataque()
	

func _physics_process(delta: float) -> void:
	match res.get_tipo_de_ataque():
		ArmaResource.tipo_ataque.arco:
			ataque_en_arco(delta)

func _cargar_hitbox() -> void:
	hitbox.polygon = res.get_hitbox_area()

func _start_cd(time: float) -> void:
	estado_actual = estado.en_cooldown
	cooldown_timer.wait_time = time
	cooldown_timer.start()

func _start_wait_time(time: float) -> void:
	esperando_timer.wait_time = time
	esperando_timer.start()

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("usar_mano_izq") and estado_actual == estado.lista:
		print("usando mano izquierda")
		usar()
	
	if Input.is_action_just_pressed("usar_mano_der") and estado_actual == estado.lista:
		print("usando mano derecha")
		usar()

func _on_cooldown_timer_timeout() -> void:
	print("termino cd")
	estado_actual = estado.lista

func _on_esperando_timer_timeout() -> void:
	print("termino espera")
	estado_actual = estado.volviendo


func ataque_en_arco(delta: float) -> void:
	if estado_actual == estado.atacando:
		var rotacion = res.get_speed() * delta
		angulo_acumulado += rotacion
		
		var arco_total = res.get_atk_arc()
		if angulo_acumulado >= arco_total:
			rotacion -= angulo_acumulado - arco_total
			terminar_ataque()
			_start_wait_time(res.get_wait_t())
		
		pivote.rotate(rotacion)
	
	if estado_actual == estado.volviendo:
		var rotacion = - res.get_return_speed() * delta
		
		if pivote.rotation + rotacion <= 0.0:
			pivote.rotation = 0.0
			_start_cd(res.get_cd())
			return
		
		pivote.rotate(rotacion)

func empezar_ataque() -> void:
	angulo_acumulado = 0.0
	estado_actual = estado.atacando
	hitbox.disabled = false

func terminar_ataque() -> void:
	estado_actual = estado.esperando
	hitbox.disabled = true

func _on_area_2d_body_entered(body: Node2D) -> void:
	print("entro un body: %s" % body.name)

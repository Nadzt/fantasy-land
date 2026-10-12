class_name ArmaMelee extends Node2D

@export_group("recurso")
@export var res: ArmaResource

@export_group("componentes")
@export var sprite: Sprite2D
@export var pivote: Node2D
@export var container: Node2D
@export var hitbox: CollisionPolygon2D
@export var cooldown_timer: Timer

@export_group("animacion de ataque")
var esta_atacando: bool
var esta_volviendo: bool
var angulo_acumulado: float = 0.0


func _ready() -> void:
	sprite.texture = res.get_sprite()
	container.position.y = res.get_pos_mano()
	_cargar_hitbox()
	
	# ver poligones
	#var collision_polygon_2d: CollisionPolygon2D = $Pivote/Container/Area2D/CollisionPolygon2D
	#for x in collision_polygon_2d.polygon:
		#print(x)

func usar() -> void:
	print("usando arma")
	esta_atacando = true
	angulo_acumulado = 0.0

func _physics_process(delta: float) -> void:
	if esta_atacando:
		var rotacion = res.get_speed() * delta
		angulo_acumulado += rotacion
		
		var arco_total = res.get_atk_arc()
		if angulo_acumulado >= arco_total:
			rotacion -= angulo_acumulado - arco_total
			esta_atacando = false
			esta_volviendo = true
		
		pivote.rotate(rotacion)
	
	if esta_volviendo: 
		var rotacion = - res.get_return_speed() * delta
		
		if pivote.rotation + rotacion <= 0.0:
			pivote.rotation = 0.0
			esta_volviendo = false
			_start_cd(res.get_cd())
			return
		
		pivote.rotate(rotacion)

func _cargar_hitbox() -> void:
	hitbox.polygon = res.get_hitbox_area()

func _start_cd(time: float) -> void:
	cooldown_timer.wait_time = time
	cooldown_timer.start()

func _unhandled_input(event: InputEvent) -> void:
	var puede_atacar: bool = !esta_atacando and !esta_volviendo and cooldown_timer.is_stopped()
	
	if Input.is_action_just_pressed("usar_mano_izq") and puede_atacar:
		print("usando mano izquierda")
		usar()
	
	if Input.is_action_just_pressed("usar_mano_der") and puede_atacar:
		print("usando mano derecha")
		usar()


func _on_cooldown_timer_timeout() -> void:
	pass # Replace with function body.

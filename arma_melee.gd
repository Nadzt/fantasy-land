class_name ArmaMelee extends Node2D

@export_group("recurso")
@export var res: ArmaResource

@export_group("componentes")
@export var sprite: Sprite2D
@export var pivote: Node2D
@export var container: Node2D
@export var hitbox: CollisionPolygon2D

@export_group("animacion de ataque")
var esta_atacando: bool
var esta_volviendo: bool
var velocidad_ataque: float = 20
var arco_total: float = 2.75
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
		var rotacion = velocidad_ataque * delta
		angulo_acumulado += rotacion
		
		if angulo_acumulado >= arco_total:
			rotacion -= angulo_acumulado - arco_total
			esta_atacando = false
			esta_volviendo = true
		
		pivote.rotate(rotacion)
	
	if esta_volviendo: 
		var rotacion = -velocidad_ataque * 1 * delta
		
		if pivote.rotation + rotacion <= 0.0:
			pivote.rotation = 0.0
			esta_volviendo = false
			return
		
		pivote.rotate(rotacion)

func _cargar_hitbox() -> void:
	hitbox.polygon = res.get_hitbox_area()


func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("usar_mano_izq"):
		print("usando mano izquierda")
		usar()
	
	if Input.is_action_just_pressed("usar_mano_der"):
		print("usando mano derecha")
		usar()

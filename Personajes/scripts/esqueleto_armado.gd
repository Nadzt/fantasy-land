class_name EsqueletoArmado
extends Enemigo

@export var velocidad: float = 70.0
@export var rango_deteccion: float = 100.0  
@export var rango_detencion: float = 25.0   

var jugador: Jugador = null
#@onready var arma: Node2D = $Arma

func _init() -> void:
	super(50)
	_vida = 50
	_fuerza = 15
	_defensa = 20
	
func _ready() -> void:
	jugador = get_tree().get_first_node_in_group("Jugador")

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta / 2

	if jugador and is_instance_valid(jugador):
		var distancia = global_position.distance_to(jugador.global_position)
		
		if distancia <= rango_deteccion and distancia > rango_detencion:
			var direccion = (jugador.global_position - global_position).normalized()  
			velocity.x = direccion.x * velocidad
			
			sprite.play("correr")  
			sprite.flip_h = direccion.x < 0
			
			#if arma:  
				#arma.scale.x = -1 if sprite.flip_h else 1
				
		else:  
			velocity.x = move_toward(velocity.x, 0, velocidad * delta)    
			sprite.play("idle")  
	else:  
		velocity.x = move_toward(velocity.x, 0, velocidad * delta)
		sprite.play("idle")
			
	move_and_slide()

func atacar() -> void:
	print("El esqueleto armado ataca con su arma.")

func soltar_item() -> void:
	pass

func _morir() -> void:
	#if GameManager:
		#GameManager.sumar_puntos(_puntaje)
	sprite.play("morir")
	await sprite.animation_finished
	soltar_item()
	super._morir()

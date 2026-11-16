class_name Jefe
extends Enemigo

@export var velocidad: float = 60.0
@export var rango_deteccion: float = 110.0  
@export var rango_detencion: float = 30.0 

@onready var alcance:CollisionShape2D = $"AlcanceGuadaña/Alcance"
@onready var _atacando: bool = false

@export var area_1: Area2D
@export var area_2: Area2D
@export var drop_gema: PackedScene

func _init():
	super(100) #puntaje 
	_vida = 1000

func _ready() -> void:
	super._ready()
	sprite.play("idle")

func _physics_process(delta: float) -> void:
	if _muerto:
		return
	
	if _atacando:
		return
	
	super._physics_process(delta)
		
	if jugador and is_instance_valid(jugador):
		var distancia = global_position.distance_to(jugador.global_position)
		
		if distancia <= rango_deteccion and distancia > rango_detencion:
			var direccion = (jugador.global_position - global_position).normalized()  
			velocity.x = direccion.x * velocidad
			
			sprite.play("walk")
			var mira_hacia_izquierda: bool = direccion.x < 0
			sprite.flip_h = mira_hacia_izquierda
			area_1.scale.x = -1 if mira_hacia_izquierda else 1
			area_2.scale.x = -1 if mira_hacia_izquierda else 1
		else: 
			velocity.x = move_toward(velocity.x, 0, velocidad * delta)    
			sprite.play("idle")
			
			if distancia <= rango_detencion:
					atacar()
	else:  
		velocity.x = move_toward(velocity.x, 0, velocidad * delta)
		sprite.play("idle")
			
	move_and_slide()

func atacar() -> void :
	if jugador and is_instance_valid(jugador) and !_atacando:
		_atacando = true
		sprite.play("attack")
		await sprite.animation_finished
		_atacando = false
		alcance.disabled = true
		sprite.play("idle")
		
	
	

func soltar_item() -> void :
	if not drop_gema:
		return
		
	var nuevo_drop: Gema = drop_gema.instantiate()
	nuevo_drop.global_position = global_position
	
	# Buscamos el contenedor "Drops" o usamos la escena actual si no existe
	var contenedor = get_tree().current_scene.get_node_or_null("Drops")
	if contenedor == null:
		contenedor = get_tree().current_scene
		
	contenedor.call_deferred("add_child", nuevo_drop)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Jugador:
		atacar()

func _on_alcance_guadaña_body_entered(body: Node2D) -> void:
	if body is Jugador:
		jugador.recibir_dmg(_fuerza)
		print("El jefe hizo daño")
		alcance.set_deferred("disabled", true)


func _on_animated_sprite_2d_frame_changed() -> void:
	if sprite.animation == "attack":
		if sprite.frame == 5 or sprite.frame == 6 and jugador:
			alcance.disabled = false
		else:
			alcance.disabled = true

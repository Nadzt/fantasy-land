class_name JefeOrco
extends EnemigoConArma

signal jefe_muerto

@export var velocidad: float = 60.0
@export var rango_deteccion: float = 170.0  
@export var rango_detencion: float = 120.0   

@export var drop_gema: PackedScene
#@onready var arma: Node2D = $Arma

func _init() -> void:
	super(100)
	_vida = 700
	_fuerza = 20
	_defensa = 30

func _ready() -> void:
	super._ready()
	jefe_muerto.connect(GameManager.jefe_fue_derrotado)

func _physics_process(delta: float) -> void:
	if _muerto:
		return
	
	super._physics_process(delta)
		
	if jugador and is_instance_valid(jugador):
		var distancia = global_position.distance_to(jugador.global_position)
		
		if distancia <= rango_deteccion and distancia > rango_detencion:
			var direccion = (jugador.global_position - global_position).normalized()  
			velocity.x = direccion.x * velocidad
			
			sprite.play("correr")
			var mira_hacia_izquierda: bool = direccion.x < 0
			sprite.flip_h = mira_hacia_izquierda
			cambiar_pos_manos(mira_hacia_izquierda)
			cambiar_arma_principal(mira_hacia_izquierda)
		else: 
			velocity.x = move_toward(velocity.x, 0, velocidad * delta)    
			sprite.play("idle")
			
			if distancia <= rango_detencion:
				if intentar_atacar():
					atacar()
	else:  
		velocity.x = move_toward(velocity.x, 0, velocidad * delta)
		sprite.play("idle")
			
	move_and_slide()

func atacar() -> void:
	print("Jefe te hace daño")

func soltar_item() -> void:
	if not drop_gema:
		return
	var nuevo_drop: Gema = drop_gema.instantiate()
	nuevo_drop.global_position = global_position
	get_tree().current_scene.get_node("Gemas").call_deferred("add_child", nuevo_drop)

func _morir() -> void:
	super._morir()
	jefe_muerto.emit()

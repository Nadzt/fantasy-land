class_name EsqueletoArmado
extends EnemigoConArma

@export var velocidad: float = 70.0
@export var rango_deteccion: float = 100.0  
@export var rango_detencion: float = 25.0   

#@onready var arma: Node2D = $Arma

func _init() -> void:
	super(50)
	_vida = 50
	_fuerza = 15
	_defensa = 20

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
	print("El esqueleto armado ataca.")

func soltar_item() -> void:
	print("El esqueleto armado soltó un arco")

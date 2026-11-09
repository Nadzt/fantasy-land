class_name OjoVolador
extends Enemigo

@export var velocidad: float = 70.0
@export var rango_deteccion: float = 200.0

var jugador: Jugador = null

func _init() -> void:
	super(25) #puntaje 
	_vida = 30
	_fuerza = 10
	_defensa = 2
	
func _ready() -> void:
	jugador = get_tree().get_first_node_in_group("Jugador")
	sprite.play("volar")
	
func _physics_process(_delta: float) -> void:
	
	if jugador:
		var distancia = global_position.distance_to(jugador.global_position)
		
		if distancia <= rango_deteccion:
			var direccion = (jugador.global_position - global_position).normalized()
			velocity = direccion * velocidad
			
			# Voltear sprite 
			if sprite:
				sprite.flip_h = direccion.x < 0
		else:
			velocity = lerp(velocity, Vector2.ZERO, 0.1)
			

	move_and_slide()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Jugador:
		atacar()

func atacar() -> void:
	if jugador and is_instance_valid(jugador):
		jugador.recibir_dmg(_fuerza)
		print("¡El ojo atacó al jugador e hizo ", _fuerza, " de daño!")

func soltar_item() -> void:
	print("El ojo soltó una moneda")

func _morir() -> void:
	#if algo así? GameManager:
		#GameManager.sumar_puntos(_puntaje)
	soltar_item()
	super._morir()

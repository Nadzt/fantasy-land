class_name OjoVolador
extends Enemigo

@export var velocidad: float = 120.0
@export var rango_deteccion: float = 300.0

var jugador: Jugador = null

func _init() -> void:
	super(25) #puntaje 
	_vida = 30
	_fuerza = 10
	_defensa = 2

	
func _ready() -> void:
	jugador = buscar_jugador(get_tree().root)


func buscar_jugador(nodo: Node) -> Node:
	if nodo is Jugador:
		return nodo
	for hijo in nodo.get_children():
		var encontrado = buscar_jugador(hijo)
		if encontrado:
			return encontrado
	return null

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

func atacar() -> void:
	pass

func soltar_item() -> void:
	print("El ojo soltó una moneda")

func _morir() -> void:
	#if GameManager:
		#GameManager.sumar_puntos(_puntaje)
	soltar_item()
	super._morir()

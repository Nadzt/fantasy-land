class_name Orco
extends EnemigoConArma

@export var velocidad: float = 70.0

func _init() -> void:
	super(70) 

	_vida = 65
	_fuerza = 20
	_defensa = 5

func _ready() -> void:
	super._ready()
	sprite.play("correr")

func _physics_process(delta: float) -> void:
	if _muerto:
		return
		
	super._physics_process(delta)

	# Este lo hice hacia la derecha
	velocity.x = velocidad

	# Agregar estas 2 lineas si el orco de sa vuelta:	
	#cambiar_pos_manos(mira_hacia_izquierda)
	#cambiar_arma_principal(mira_hacia_izquierda)

	move_and_slide()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Jugador:
		atacar()

func atacar() -> void:
	if intentar_atacar():
		print("¡El orco atacó al jugador e hizo ", _fuerza, " de daño!")

func soltar_item() -> void:
	print("El orco suelta una espada")

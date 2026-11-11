class_name EnemigoConArma
extends Enemigo

@export var tiempo_cooldown: float = 1.5     
var _tiempo_actual_ataque: float = 0.0    

@onready var arma: Node2D = get_node_or_null("Arma")

func _physics_process(delta: float) -> void:
	if _tiempo_actual_ataque > 0:
		_tiempo_actual_ataque -= delta

func intentar_atacar() -> bool:
	if _tiempo_actual_ataque <= 0 and jugador and is_instance_valid(jugador):
		
		if arma and arma.has_method("usar"):
			arma.usar()
		else:
			jugador.recibir_dmg(_fuerza)
			
		_tiempo_actual_ataque = tiempo_cooldown # acá reinicio el cooldown
		return true
		
	return false

func atacar() -> void:
	intentar_atacar()

func soltar_item() -> void:
	print("Solté un item")

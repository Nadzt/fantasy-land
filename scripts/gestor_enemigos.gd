extends Node2D
class_name GestorEnemigos

@export var enemigos_posibles: Array[PackedScene]
@export var tiempo_espera: Timer

func _ready():
	_crear_enemigo(0.5)

func _crear_enemigo(tiempo: float = 12):
	tiempo_espera.wait_time = tiempo
	tiempo_espera.start()

func instanciar_enemigo() -> void:
	var escena_elegida = enemigos_posibles.pick_random()
	var enemigo = escena_elegida.instantiate()
	enemigo.global_position = global_position
	enemigo.enemigo_muerto.connect(_crear_enemigo)
	get_tree().current_scene.get_node("Enemigos").call_deferred("add_child", enemigo)

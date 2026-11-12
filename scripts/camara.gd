extends Camera2D

@export var player: Jugador

func _physics_process(delta: float) -> void:
	position = player.global_position

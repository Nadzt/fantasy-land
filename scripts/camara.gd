extends Camera2D

@export var player: Jugador

func _physics_process(_delta: float) -> void:
	if player:
		position = player.global_position

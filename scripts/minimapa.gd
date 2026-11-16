extends SubViewport

@export var camera_2d: Camera2D
@export var jugador: Jugador

func _ready() -> void:
	world_2d = get_tree().root.world_2d

func _physics_process(_delta: float) -> void:
	if jugador:
		camera_2d.global_position = jugador.position 

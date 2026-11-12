extends SubViewport

@export var camera_2d: Camera2D
@export var jugador: Jugador

func _ready() -> void:
	world_2d = get_tree().root.world_2d

func _physics_process(delta: float) -> void:
	camera_2d.position = jugador.global_position

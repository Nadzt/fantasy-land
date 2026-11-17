extends CanvasLayer
@export var gema_jefe_1: PackedScene
@export var gema_inactiva: Resource
@export var gema_activa:Resource
@onready var icono_gema_1: TextureRect = $HBoxContainer/Gema1


func _ready() -> void:
	GameManager.gema_conseguida.connect(_on_gema_obtenida)
	if GameManager.gemas_obtenidas.has(gema_jefe_1):
		icono_gema_1.texture = gema_activa
	else:
		icono_gema_1.texture = gema_inactiva

func _on_gema_obtenida(escena: PackedScene) -> void:
	if escena == gema_jefe_1:
		icono_gema_1.texture = gema_activa

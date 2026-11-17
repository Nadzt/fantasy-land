extends CanvasLayer
@export var gema_jefe_1: String = "gema_jefe_parca"
@export var gema_jefe_2: String = "gema_jefe_orco"

@export var gema_inactiva: Resource
@export var gema_activa:Resource

@onready var icono_gema_1: TextureRect = $MarginContainer/HBoxContainer/TextureRect
@onready var icono_gema_2: TextureRect = $MarginContainer/HBoxContainer/TextureRect2


func _ready() -> void:
	GameManager.gema_conseguida.connect(_on_gema_obtenida)
	
	icono_gema_1.texture = gema_activa if GameManager.gemas_obtenidas.has(gema_jefe_1) else gema_inactiva
	icono_gema_2.texture = gema_activa if GameManager.gemas_obtenidas.has(gema_jefe_2) else gema_inactiva
	
func _on_gema_obtenida(gema: String) -> void:
	if gema == gema_jefe_1:
		icono_gema_1.texture = gema_activa
	elif gema == gema_jefe_2:
		icono_gema_2.texture = gema_activa

class_name Gema extends Node2D

@export var id_gema: String = "gema_jefe"

var jugador_en_rango: Jugador = null
@onready var coleccionable: RichTextLabel = $Coleccionable


func _ready() -> void:
	coleccionable.hide()

func _process(_delta: float) -> void:
	if jugador_en_rango != null:
		recoger_gema()


func recoger_gema() -> void:
	GameManager.registrar_gema(id_gema)
	queue_free()

func _on_area_recoleccion_body_entered(body: Node2D) -> void:
	if body is Jugador:
		jugador_en_rango = body
		coleccionable.show()

func _on_area_recoleccion_body_exited(body: Node2D) -> void:
	if body is Jugador:
		jugador_en_rango = null
		coleccionable.hide()

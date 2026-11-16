class_name Drop extends Node2D

## Sprite del drop
@export var sprite: Sprite2D
## Resource del drop
@export var res: ArmaResource

@export var jugador_en_rango: Jugador
@export var indicaciones: RichTextLabel

func _ready() -> void:
	indicaciones.hide()

## si el jugador entra al area le permite agarrarla
func _on_area_recoleccion_body_entered(body: Node2D) -> void:
	if body is Jugador:
		jugador_en_rango = body
		indicaciones.show()
	
## si el jugador sale del area se esconde el texto y no le permite agarrarla
func _on_area_recoleccion_body_exited(body: Node2D) -> void:
	if body is Jugador:
		jugador_en_rango = null
		indicaciones.hide()

func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("cambiar_arma_der") and jugador_en_rango:
		cambiar_arma_der_jugador()
		queue_free()
		return
	
	if Input.is_action_just_pressed("cambiar_arma_izq") and jugador_en_rango:
		cambiar_arma_izq_jugador()
		queue_free()
		return

func cambiar_arma_izq_jugador() -> void:
	jugador_en_rango.agarrar_arma(res, true)

func cambiar_arma_der_jugador() -> void:
	jugador_en_rango.agarrar_arma(res, false)

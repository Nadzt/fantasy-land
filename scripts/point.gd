class_name Point extends Area2D

@export var sonido_score: AudioStreamPlayer2D 
@export var collision_shape_2d: CollisionShape2D

func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("Jugador"):
		return
		
	agarrar()

func agarrar() -> void:
	visible = false
	collision_shape_2d.set_deferred("disabled", true)
	GameManager.sumar_puntos(15)
	
	sonido_score.play()
	await sonido_score.finished
	queue_free()

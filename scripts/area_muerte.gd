class_name AreaMuerte extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body is Jugador:
		body.game_over.emit()
		body.recibir_dmg(10000)

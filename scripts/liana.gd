extends Area2D

func _on_body_entered(body) -> void:
	if body is Jugador:
		body.puede_trepar = true
		body._posicionx_trepar = global_position.x

func _on_body_exited(body) -> void:
	if body is Jugador:
		body.puede_trepar = false

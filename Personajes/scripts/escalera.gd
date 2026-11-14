extends Area2D

func _on_body_entered(body) -> void:
	if body is Jugador:
		body.puede_trepar = true



func _on_body_exited(body) -> void:
	if body is Jugador:
		body.puede_trepar = false

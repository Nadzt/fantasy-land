class_name Liana extends Area2D

func _on_body_entered(body) -> void:
	if body is Jugador:
		habilitar_trepar(body)

func _on_body_exited(body) -> void:
	if body is Jugador:
		deshabilitar_trepar(body)

func habilitar_trepar(body: Jugador) -> void:
	body.puede_trepar = true
	body._posicionx_trepar = global_position.x

func deshabilitar_trepar(body: Jugador) -> void:
	body.puede_trepar = false
	body._saltos_hechos = 1

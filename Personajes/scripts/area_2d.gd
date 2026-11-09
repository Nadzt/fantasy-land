extends Area2D
@export var dano := 10

func _on_body_entered(body):
	if body is Jugador:
		body.recibir_dmg(dano)

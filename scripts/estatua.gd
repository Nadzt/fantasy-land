class_name Estatua extends Node2D

@export var indicaciones: RichTextLabel
@export var respuesta: RichTextLabel
var jugador_en_rango: Jugador

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Jugador:
		indicaciones.show()
		respuesta.show()
		jugador_en_rango = body

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Jugador:
		indicaciones.hide()
		respuesta.hide()
		respuesta.text = ""
		jugador_en_rango = null

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("interaccion_1") and jugador_en_rango:
		if GameManager.get_puntos() < 100:
			respuesta.text = "No tenes suficientes puntos :'("
			return
		curar_jugador()
	
	if Input.is_action_just_pressed("interaccion_2") and jugador_en_rango:
		if GameManager.get_puntos() < 200:
			respuesta.text = "No tenes suficientes puntos :'("
			return
		enormizar() 

func curar_jugador() -> void:
	GameManager.restar_puntos(100)
	respuesta.text = "Solo tu puedes oirme, invocador ah"
	jugador_en_rango.set_vida(jugador_en_rango.get_hp_max())

func enormizar() -> void:
	GameManager.restar_puntos(200)
	respuesta.text = "[shake rate=20 level=2][color='#E924FF']Enormizar[/color][/shake]"
	var signo: int = sign(jugador_en_rango.mano_derecha.arma.scale.x)
	if abs(jugador_en_rango.mano_derecha.arma.scale.x) < 2:
		jugador_en_rango.mano_derecha.arma.scale += Vector2(0.2 * signo, 0.2)
	if abs(jugador_en_rango.mano_izquierda.arma.scale.x) < 2:
		jugador_en_rango.mano_izquierda.arma.scale += Vector2(0.2 * signo, 0.2)
	

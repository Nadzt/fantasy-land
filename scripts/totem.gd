class_name Totem extends Node2D

@export var indicaciones: RichTextLabel
@export var respuesta: RichTextLabel
var jugador_en_rango: Jugador
@export var sfx_player: AudioStreamPlayer2D

const SFX_VOLI = preload("uid://n21lvkppypqa")
const SFX_ORNN = preload("uid://dvix40tdy3maf")

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
		if GameManager.get_puntos() < 200:
			respuesta.text = "No tenes suficientes puntos :'("
			return
		otorgar_buff_de_la_tormenta()
	
	
	if Input.is_action_just_pressed("interaccion_2") and jugador_en_rango:
		if GameManager.get_puntos() < 200:
			respuesta.text = "No tenes suficientes puntos :'("
			return
		mejorar_arma()

func otorgar_buff_de_la_tormenta() -> void:
	GameManager.restar_puntos(200)
	respuesta.hide()
	respuesta.text = "[shake rate=20 level=2][color='#E924FF']!!![/color][/shake]"
	jugador_en_rango.set_max_hp(jugador_en_rango.get_vida_max() + 100)
	jugador_en_rango.mano_derecha.arma.buffear_atk_speed(50)
	jugador_en_rango.mano_derecha.arma.buffear_rango(50)
	jugador_en_rango.mano_derecha.arma.buffear_dmg(5)
	jugador_en_rango.mano_izquierda.arma.buffear_atk_speed(50)
	jugador_en_rango.mano_izquierda.arma.buffear_rango(50)
	jugador_en_rango.mano_izquierda.arma.buffear_dmg(5)
	sfx_player.stream = SFX_VOLI
	sfx_player.play()

func mejorar_arma() -> void:
	GameManager.restar_puntos(200)
	respuesta.text = "[shake rate=20 level=2][color='#9C3228']!!![/color][/shake]"
	jugador_en_rango.mano_derecha.arma.buffear_dmg(15)
	jugador_en_rango.mano_derecha.arma.buffear_multiplicador(.35)
	jugador_en_rango.mano_izquierda.arma.buffear_dmg(15)
	jugador_en_rango.mano_izquierda.arma.buffear_multiplicador(.35)
	sfx_player.stream = SFX_ORNN
	sfx_player.play()

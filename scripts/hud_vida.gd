extends TextureProgressBar

@export var jugador: Jugador
@export var label: Label

func _ready() -> void:
	jugador.cambio_en_vida.connect(actualizar)
	actualizar()

func actualizar() -> void:
	var vida_actual = jugador.get_vida()
	var vida_max = jugador.get_hp_max()
	@warning_ignore("integer_division")
	value = vida_actual * 100 / vida_max
	label.text = "%s/%s" % [vida_actual, vida_max]

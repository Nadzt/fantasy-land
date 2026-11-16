extends TextureProgressBar

@export var jugador: Jugador

func _ready() -> void:
	jugador.cambio_en_vida.connect(actualizar)
	actualizar()
	
func actualizar():
	value = jugador._vida * 100 / jugador.VIDA_MAX

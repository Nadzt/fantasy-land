class_name ArmaResource extends Resource

@export_group("sprite y area2d")
@export var _sprite: AtlasTexture
@export var _pos_y_mano: float
@export var _area_polygon_array: PackedVector2Array

@export_group("stats")
@export var _nombre: String
@export var _dmg: int
@export var _es_de_dos_manos: bool

@export_group("animacion")
@export var _arco_de_ataque: float
@export var _speed: float
@export var _speed_return: float
@export var _cooldown: float

## retorna el sprite del arma
func get_sprite() -> AtlasTexture:
	return _sprite

## retorna la posicion del mango del arma respecto al centro
func get_pos_mano() -> float:
	return _pos_y_mano

## retorna las coordenadas del hitbox del area2d
func get_hitbox_area() -> PackedVector2Array:
	return _area_polygon_array

## la velocidad en la que el arma ataca o la velocidad del proyectil
func get_speed() -> float:
	return _speed
	
## la velocidad en la que vuelve el arma a su posicion original
func get_return_speed() -> float:
	return _speed_return

## devuelve el cd del arma
func get_cd() -> float:
	return _cooldown

## devuelve el arco que realiza el arma para el ataque en radianes
func get_atk_arc() -> float:
	return _arco_de_ataque

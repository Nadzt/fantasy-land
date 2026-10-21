class_name ArmaResource extends Resource

enum tipo_ataque {
	## un arma que ataca en un arco, tipo slash
	arco,
	## un arma que ataca con una estocada
	estocada
}

@export_group("sprite y area2d")
@export var _sprite: AtlasTexture
@export var _pos_mano: Vector2
@export var _area_polygon_array: PackedVector2Array

@export_group("data")
@export var _nombre: String
@export var _dmg: int
@export var _es_de_dos_manos: bool

@export_group("animacion")
## tipo de ataque, puede ser en arco (slash) o estocada (stabby stab)
@export var _tipo_ataque: tipo_ataque
## arco de ataque para un ataque de tipo slash (en radianes)
@export var _arco_de_ataque: float
## la velocidad en la que se mueve el arma cuando ataca
@export var _speed: float
## el tiempo de espera que esta en la posicion final del ataque antes de volver
@export var _speed_return: float
## la velocidad en la que vuelve despues de atacar
@export var _wait_time: float
## el tiempo que tarda en habilitarse el proximo ataque
@export var _cooldown: float

@export var _preparacion: float = 20
@export var _largo_estocada: float = 100

## retorna el sprite del arma
func get_sprite() -> AtlasTexture:
	return _sprite

## retorna la posicion del mango del arma respecto al centro
func get_pos_mano() -> Vector2:
	return _pos_mano

## retorna las coordenadas del hitbox del area2d
func get_hitbox_area() -> PackedVector2Array:
	return _area_polygon_array

func get_nombre() -> String:
	return _nombre
	
func get_dmg() -> int:
	return _dmg
	
func es_de_dos_manos() -> bool:
	return _es_de_dos_manos

## la velocidad en la que el arma ataca o la velocidad del proyectil
func get_speed() -> float:
	return _speed
	
## la velocidad en la que vuelve el arma a su posicion original
func get_return_speed() -> float:
	return _speed_return

## devuelve el cd del arma
func get_cd() -> float:
	return _cooldown

## devuelve el tiempo que el arma espera hasta empezra la animacion de volver
func get_wait_t() -> float:
	return _wait_time

## devuelve el arco que realiza el arma para el ataque en radianes
func get_atk_arc() -> float:
	return _arco_de_ataque

## devuelve el tipo de ataque de esa arma
func get_tipo_de_ataque() -> tipo_ataque:
	return _tipo_ataque

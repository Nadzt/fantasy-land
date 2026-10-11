class_name ArmaResource extends Resource

@export_group("sprite y area2d")
@export var _sprite: AtlasTexture
@export var _pos_y_mano: float
@export var _area_polygon_array: PackedVector2Array

@export_group("stats")
@export var _nombre: String
@export var _dmg: int
@export var _attack_speed: float
@export var _es_de_dos_manos: bool

## retorna el sprite del arma
func get_sprite() -> AtlasTexture:
	return _sprite

## retorna la posicion del mango del arma respecto al centro
func get_pos_mano() -> float:
	return _pos_y_mano

## retorna las coordenadas del hitbox del area2d
func get_hitbox_area() -> PackedVector2Array:
	return _area_polygon_array

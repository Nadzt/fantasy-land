class_name ArmaMelee extends Node2D

## estados en los que se puede encontrar un arma
enum estado {
	lista,
	anticipacion,
	atacando,
	volviendo,
	en_cooldown
}

## si esta on, imprime en consola informacion extra
@export var debug: bool = false

## si esta on, permite usar armas sin un personaje
@export var test: bool = false

## el multiplicador de daño que hace el jugador con las armas
@export var multiplicador_jugador: float = 2
## el multiplicador de daño que hacen los  con las armas
@export var multiplicador_enemigos: float = 1

## el recurso del arma
@export var res: ArmaResource

@export_group("Info general")
## nombre del arma
@export var nombre: String
## daño del arma
@export var dmg: int
## si es de 2 manos
@export var es_de_dos_manos: bool
## direccion de donde esta mirando el arma
@export var dir_izquierda: bool = false
## layer que lee el arma, 1 para jugador y 3 para enemigos
@export var layer_de_dmg: int = 3

@export_group("Componentes")
## Sprite del arma
@export var sprite: Sprite2D
## la hubicacion de la mano, es el pivote que se rota para las animaciones
@export var pivote: Node2D
## el container que se mueve para que el pivote se alinie con la mano del arma
@export var container: Node2D
## hitbox del arma
@export var hitbox: CollisionPolygon2D
## Timer que se usa para esperar las transiciones
@export var timer_de_espera: Timer
## area de hitbox
@export var hitbox_area: Area2D

@export_group("stats de animacion")
## arco de ataque para un ataque de tipo slash (en radianes)
@export var animaciones_de_ataque: Array[AnimacionAtaqueResource]

@export_group("Ataque Actual")
## index de la animacion actual
@export var idx_ataque_actual: int = 0
## animacion actual
@export var animacion_actual: AnimacionAtaqueResource

@export_group("Estado del ataque actual")
## indica si se termino de trasladar
@export var estado_actual: estado = estado.lista

## indica si se termino la rotacion
@export var rotacion_terminada: bool
## indica si se termino de trasladar
@export var traslacion_terminada: bool

## el progreso de tiempo en el que se encuentra la animacion de rotacion
@export var rotacion_progreso: float
## el progreso de tiempo en el que se encuentra la animacion de traslacion
@export var traslacion_progreso: float

@export_group("Variables de la animacion actual")
## determina si la animacion hace una rotacion o no
@export var aplicar_rotacion: bool
## determina si la animacion hace una traslacion o no
@export var aplicar_traslacion: bool
## tiempo de espera para que se ejecute la siguiente animacion o cooldown del arma
@export var tiempo_espera_siguiente_animacion: float

## el tiempo total que dura la rotacion
@export var rotacion_duracion: float
## la curva de animacion de esa rotacion
@export var rotacion_curva_ease: float
## la distanacia objetivo que se quiere trasladare, en radianes
@export var rotacion_distancia: float
## Si la animacion tiene un offeset o no
@export var rotacion_offset: float

## el tiempo total que dura la traslacion
@export var traslacion_duracion: float
## la curva de animacion de esa traslacion
@export var traslacion_curva_ease: float
## la distanacia objetivo que se quiere trasladar
@export var traslacion_distancia: float
## Si la animacion tiene un offeset o no
@export var traslacion_offset: float


#region funciones dev para debug

## ejecuta una funcion si esta modo debug activado
func print_coords_dev(callback: Callable) -> void:
	if debug:
		callback.call()

## imprime en pantalla solo si esta modo debug
func print_dev(string: String) -> void:
	if debug:
		print(string)

## me muestra las coordenadas de hitbox que cree para crear recursos mas rapido
func print_coords_hitbox() -> void:
	# ver poligones
	var collision_polygon_2d: CollisionPolygon2D = $Pivote/Container/Area2D/CollisionPolygon2D
	for x in collision_polygon_2d.polygon:
		print(x)

#endregion


## TODO: Pasar al jugador:
func _unhandled_input(_event: InputEvent) -> void:
	if !test:
		return
	
	if Input.is_action_just_pressed("usar_mano_izq") and estado_actual == estado.lista:
		print_dev("usando mano izquierda")
		usar()
	
	if Input.is_action_just_pressed("usar_mano_der") and estado_actual == estado.lista:
		print_dev("usando mano derecha")
		usar()

#
func _ready() -> void:
	print_coords_dev(print_coords_hitbox)
	
	# cargado de datos
	_cargar_info_general()
	_cargar_animaciones()
	_cargar_sprite_y_alinear()
	cambiar_hitbox_area()
	
	# setup de la animacion
	animacion_actual = animaciones_de_ataque.get(0)
	print_dev("%s: duracion de animacion actual: %s" % [nombre, animacion_actual.get_duracion_total()])



#
func _physics_process(delta: float) -> void:
	# animaciones de ataque
	ataque_en_estocada(delta)

#region inicializacion

## carga el sprite, posiciona el origen en el mango y carga el hitbox
func _cargar_sprite_y_alinear() -> void:
	print_dev("sprite cargados")
	sprite.texture = res.get_sprite()
	container.position = res.get_pos_mano()
	hitbox.polygon = res.get_hitbox_area()
	hitbox.disabled = true
	

## carga la info general del arma
func _cargar_info_general() -> void:
	print_dev("stats de arma cargados")
	nombre = res.get_nombre()
	dmg = res.get_dmg()
	es_de_dos_manos = res.es_de_dos_manos()

## carga los stats que uso para las animaciones
func _cargar_animaciones() -> void:
	print_dev("stats de animacion cargados")
	animaciones_de_ataque = res.get_animaciones()

#endregion

## empieza un ataque
func usar() -> void:
	print_dev("%s: usando arma" % nombre)
	if animaciones_de_ataque.is_empty():
		printerr("%s no tiene animaciones" % nombre)
		return
	
	if estado_actual == estado.lista:
		iniciar_ataque()

#region cambio de estados de ciclo de vida de un ataque

## reinicia las variables para la proxima animacion
func reiniciar_variables() -> void:
	# variables de las rotaciones
	rotacion_terminada = false
	rotacion_progreso = 0.0
	rotacion_offset = 0.0
	
	# variabels de la traslacion
	traslacion_terminada = false
	traslacion_progreso = 0.0
	traslacion_offset = 0.0

## empieza el ciclo de vida de un ataque
func iniciar_ataque() -> void:
	cambiar_a_siguiente_estado()

## cambia al estado anticipacion y establece las variables
func iniciar_estado_anticipacion() -> void:
	# estado actual
	print_dev("iniciar_estado_anticipacion")
	estado_actual = estado.anticipacion
	
	# variables generales
	reiniciar_variables()
	tiempo_espera_siguiente_animacion = animacion_actual.get_ant_tiempo_espera()
	
	# variables de rotacion
	aplicar_rotacion = animacion_actual.get_ant_tiene_rotacion()
	rotacion_duracion = animacion_actual.get_ant_r_duracion()
	rotacion_curva_ease = animacion_actual.get_ant_r_curva_ease()
	rotacion_distancia = animacion_actual.get_ant_r_distancia()
	
	# variables de traslacion
	aplicar_traslacion = animacion_actual.get_ant_tiene_traslacion()
	traslacion_duracion = animacion_actual.get_ant_t_duracion()
	traslacion_curva_ease = animacion_actual.get_ant_t_curva_ease()
	traslacion_distancia = animacion_actual.get_ant_t_distancia()

## cambia al estado atacando y establece las variables
func inicia_estado_atacando() -> void:
	# estado actual
	print_dev("inicia_estado_atacando")
	estado_actual = estado.atacando
	
	# activar hitbox
	hitbox.disabled = false
	
	# variables generales
	reiniciar_variables()
	tiempo_espera_siguiente_animacion = animacion_actual.get_atk_tiempo_espera()
	
	# variables de rotacion
	aplicar_rotacion = animacion_actual.get_atk_tiene_rotacion()
	rotacion_duracion = animacion_actual.get_atk_r_duracion()
	rotacion_curva_ease = animacion_actual.get_atk_r_curva_ease()
	var distancia_r_atk = animacion_actual.get_atk_r_distancia()
	var distancia_r_ant = animacion_actual.get_ant_r_distancia()
	rotacion_distancia = distancia_r_atk
	rotacion_offset = distancia_r_ant
	
	# variables de traslacion
	aplicar_traslacion = animacion_actual.get_atk_tiene_traslacion()
	traslacion_duracion = animacion_actual.get_atk_t_duracion()
	traslacion_curva_ease = animacion_actual.get_atk_t_curva_ease()
	var distancia_t_atk = animacion_actual.get_atk_t_distancia()
	var distancia_t_ant = animacion_actual.get_ant_t_distancia()
	traslacion_distancia = distancia_t_atk + abs(distancia_t_ant)
	traslacion_offset = distancia_t_ant

## cambia al estado volviendo y establece las variables
func iniciar_estado_volviendo() -> void:
	#estado actual
	print_dev("iniciar_estado_volviendo")
	estado_actual = estado.volviendo
	
	# variables generales
	reiniciar_variables()
	aplicar_traslacion = pivote.position.x != 0
	aplicar_rotacion = pivote.rotation != 0
	
	# variables de rotacion
	rotacion_duracion = animacion_actual.get_vol_r_duracion()
	rotacion_curva_ease = animacion_actual.get_vol_r_curva_ease()
	rotacion_offset = pivote.rotation
	rotacion_distancia = -pivote.rotation
	
	# variables de traslacion
	traslacion_duracion = animacion_actual.get_vol_t_duracion()
	traslacion_curva_ease = animacion_actual.get_vol_t_curva_ease()
	traslacion_offset = pivote.position.x
	var distancia_t = abs(pivote.position.x) + animacion_actual.get_vol_t_distancia()
	traslacion_distancia = -distancia_t

## cambia al estado en cooldown y inicia el timer
func iniciar_estado_en_cooldown() -> void:
	# estado actual
	print_dev("iniciar_estado_en_cooldown")
	estado_actual = estado.en_cooldown
	
	# cooldown
	var cooldown = animacion_actual.get_cooldown()
	if cooldown == 0.0:
		iniciar_estado_listo()
		return
	
	tiempo_espera_siguiente_animacion = cooldown
	_iniciar_tiempo_de_espera(tiempo_espera_siguiente_animacion)

## cambia al estado listo
func iniciar_estado_listo() -> void:
	# estado actual
	print_dev("iniciar_estado_listo")
	estado_actual = estado.lista
	
	# variables generales
	reiniciar_variables()

#endregion

#region funciones de manejo de ataques

func ataque_en_estocada(delta: float) -> void:
	# #TODO: animacion idle
	# animo la aniticipacion del ataque
	if estado_actual == estado.anticipacion:
		traslacion_terminada = animar_movimiento_traslacion(delta)
		rotacion_terminada = animar_rotacion(delta)
	
	# animo la ida si tiene esta atacando
	if estado_actual == estado.atacando:
		traslacion_terminada = animar_movimiento_traslacion(delta)
		rotacion_terminada = animar_rotacion(delta)
	
	## animo la vuelta si tiene que volver
	if estado_actual == estado.volviendo:
		traslacion_terminada = animar_movimiento_traslacion(delta)
		rotacion_terminada = animar_rotacion(delta)
	
	#TODO: && rotacion_terminada
	if traslacion_terminada && rotacion_terminada && timer_de_espera.is_stopped():
		cambiar_a_siguiente_estado()

## empieza el timer entre que cae el arma y empieza a volver
func _iniciar_tiempo_de_espera(time: float) -> void:
	timer_de_espera.wait_time = time
	timer_de_espera.start()

## cambia el estado del ataque al siguiente estado del ciclo de vida
func cambiar_a_siguiente_estado() -> void:
	print_dev("cambiando al siguiente estado, estado actual: %s" % estado.find_key(estado_actual) )
	
	# listo -> anticipacion
	if estado_actual == estado.lista:
		iniciar_estado_anticipacion()
		return
	
	# anticipacion -> atacando
	if estado_actual == estado.anticipacion:
		# si hay un tiempo de espera, primero espera, y despues cambia
		if tiempo_espera_siguiente_animacion != 0.0:
			print_dev("inicio timer entre anticipacion-atacando")
			_iniciar_tiempo_de_espera(tiempo_espera_siguiente_animacion)
			return
		
		# una vez terminado el tiempo de espera cambia al estado "atacando"
		inicia_estado_atacando()
		return
	
	# atacando -> volviendo
	if estado_actual == estado.atacando:
		# desactivar hitbox
		hitbox.disabled = true
		
		# lo mismo que arriba
		if tiempo_espera_siguiente_animacion != 0.0:
			print_dev("inicio timer entre atacando-volviendo")
			_iniciar_tiempo_de_espera(tiempo_espera_siguiente_animacion)
			return
		
		iniciar_estado_volviendo()
		return
	
	# volviendo -> en_cooldown
	if estado_actual == estado.volviendo:
		print_dev("inicio timer de cooldown")
		iniciar_estado_en_cooldown()
		return
	
	# en_cooldown -> listo
	if estado_actual == estado.en_cooldown:
		iniciar_estado_listo()
		return


#endregion

#region callbacks de señales
## cambia el estado del arma para que empiece a volver
func _on_timer_de_espera_timeout() -> void:
	tiempo_espera_siguiente_animacion = 0.0
	print_dev("termino timer")
	cambiar_a_siguiente_estado()

## Hitbox
func _on_area_2d_body_entered(body: Node2D) -> void:
	#print("%s le pego a un body: %s" % [nombre, body.name])
	
	if body is Enemigo:
		body.recibir_dmg(dmg*multiplicador_jugador)
	
	if body is Jugador:
		body.recibir_dmg(dmg*multiplicador_enemigos)


#endregion

#region animaciones de rotacion

## anima la rotacion de un ataque
func animar_rotacion(delta: float) -> bool:
	# failsafe
	if (!aplicar_rotacion || rotacion_terminada || rotacion_duracion == 0.0 ):
		return true
	
	var animacion_terminada: bool = false
	
	# progreso de tiempo sobre el total de tiempo que tarda la animacion, va de 0 a 1
	rotacion_progreso += delta / rotacion_duracion
	rotacion_progreso = min(rotacion_progreso, 1.0)

	# progreso de movimiento sobre el total del movimiento de traslacion, tambien de 0 a 1
	# ease(,) si el 2do parametro es mayor a 1 es ease-in
	# https://byteatatime.dev/posts/easings/
	var proporcion_actual = ease(rotacion_progreso, rotacion_curva_ease)
	
	# calculo la nueva posicion
	var nuevo_valor_rotacion = (proporcion_actual * rotacion_distancia) + rotacion_offset
	
	# si es el final termino el ataque
	if rotacion_progreso >= 1.0:
		animacion_terminada = true
	
	
	pivote.rotation = nuevo_valor_rotacion
	return animacion_terminada

#endregion

#region animaciones de traslacion

## Anima la traslacion de un ataque
func animar_movimiento_traslacion(delta: float) -> bool:
	# failsafe
	if (!aplicar_traslacion || traslacion_terminada || traslacion_duracion == 0.0 ):
		return true
	
	var animacion_terminada: bool = false
	
	# progreso de tiempo sobre el total de tiempo que tarda la animacion, va de 0 a 1
	traslacion_progreso += delta / traslacion_duracion
	traslacion_progreso = min(traslacion_progreso, 1.0)
	
	# progreso de movimiento sobre el total del movimiento de traslacion, tambien de 0 a 1
	# ease(,) si el 2do parametro es mayor a 1 es ease-in
	# https://byteatatime.dev/posts/easings/
	var proporcion_actual = ease(traslacion_progreso, traslacion_curva_ease)
	
	# calculo la nueva posicion
	var nueva_pos_x = (proporcion_actual * traslacion_distancia) + traslacion_offset
	
	# si es el final termino el ataque
	if traslacion_progreso >= 1.0:
		animacion_terminada = true
	
	pivote.position.x = nueva_pos_x
	return animacion_terminada

#endregion

#region sync con personaje

## actualiza la posicion con la mano padre
func actualizar_pos() -> void:
	var parent = get_parent()
	
	if parent is Mano:
		global_position = parent.global_position

## invierte el sprite en caso de mirar a la izquierda
func invertir_por_direccion(mira_izquierda) -> void:
	if mira_izquierda:
		scale.x = abs(scale.x) * -1
	else:
		scale.x = abs(scale.x)

## cambia la layer que lee el hitbox
func cambiar_hitbox_area(layer: int = layer_de_dmg) -> void:
	hitbox_area.collision_mask = 0
	hitbox_area.set_collision_mask_value(layer, true)

#endregion

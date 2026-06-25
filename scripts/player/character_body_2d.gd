extends CharacterBody2D

@onready var animation = $AnimatedSprite2D
@onready var lyra_health = $HealthManager
@onready var lyra_ability = $AbilityManager
@onready var attackbox = $Attackbox
@onready var step_sound = $AudioStreamPlayer

@onready var ui = get_tree().get_first_node_in_group("ui")
var is_attacking = false
var facing_right = true
var is_dead = false
var respawn_position: Vector2

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

func _ready():
	add_to_group("player") #grupo conecta con la interfaz
	lyra_health.died.connect(_on_lyra_died) #recibe señal de muerte de HealthManager
	respawn_position = global_position

func _physics_process(delta):
	if is_dead:
		return
	
	var current_attack_animation = ""
	# Gravedad
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Movimiento horizontal
	var direction = Input.get_axis("ui_left", "ui_right")

	# Salto
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Ataque
	if Input.is_action_just_pressed("attack") and !is_attacking and $AbilityManager.enabled:
		is_attacking = true

		if direction != 0:
			current_attack_animation = "lyra_basic_attack+walk"
		else:
			current_attack_animation = "lyra_basic_attack"

		animation.play(current_attack_animation)
		$AbilityManager.attack()

	# Dirección del personaje
	if direction > 0:
		animation.flip_h = false
		facing_right = true
	elif direction < 0:
		animation.flip_h = true
		facing_right = false

	# Movimiento
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# Posición del hitbox de ataque
	if facing_right:
		attackbox.position.x = 0
	else:
		attackbox.position.x = -105

	# Actualizar animación
	update_animation(direction)
	move_and_slide()


func update_animation(direction):
	if is_dead:
		return
	#ataque
	if is_attacking:
		if direction != 0:
			if animation.animation == "lyra_basic_attack":
				var frame = animation.frame
				animation.play("lyra_basic_attack+walk")
				animation.frame = frame
		else:
			if animation.animation == "lyra_basic_attack+walk":
				var frame = animation.frame
				animation.play("lyra_basic_attack")
				animation.frame = frame 
		return
	
	# Animaciones de salto
	if not is_on_floor():
		if direction != 0:
			if animation.animation != "lyra_jump_walk":
				animation.play("lyra_jump+walk")
		else:
			if animation.animation != "lyra_jump":
				animation.play("lyra_jump")
		return

	# Animaciones normales
	if direction != 0:
		if animation.animation != "lyra_walk":
			animation.play("lyra_walk")
	else:
		if animation.animation != "lyra_idle":
			animation.play("lyra_idle")

#para el sonido de los pasos
var step_sounds = [ #se ahce un array con distintos tipos de pasos
	preload("res://sound/effects/pasos/PASOS 1.ogg"),
	preload("res://sound/effects/pasos/PASOS 2.ogg"),
	preload("res://sound/effects/pasos/PASOS 3.ogg"),
	preload("res://sound/effects/pasos/PASOS 4.ogg"),
	preload("res://sound/effects/pasos/PASOS 5.ogg")
]
func _on_frame_changed():
	if animation.animation == "lyra_walk":
		if animation.frame in [0, 2, 3, 5, 7, 9, 11, 13]: #frames en donde el pie toca el piso
			step_sound.stream = step_sounds.pick_random()# se elige uno random del array
			step_sound.pitch_scale = randf_range(0.8, 1.2) #se le cambia el pitch
			step_sound.play()
			
			

func _on_lyra_died():
	print("LYRA DE MURIÓ :c") #debug eliminar una vez que todo funcione!!!
	is_dead = true
	# cortar control inmediato
	velocity = Vector2.ZERO

	# opcional: desactivar sistemas
	$AbilityManager.enabled = false
	is_attacking = false

	# forzar animación de muerte (interrumpe cualquier otra)
	animation.stop()
	animation.play("lyra_defeated")
	
	# iniciar respawn
	respawn()
	

func respawn():
	await get_tree().create_timer(1.5).timeout
	is_dead = false
	global_position = respawn_position
	velocity = Vector2.ZERO
	# restaurar vida
	lyra_health.current_health = lyra_health.max_health
	lyra_health.health_changed.emit(lyra_health.current_health)
	# reactivar sistemas
	$AbilityManager.enabled = true
	is_attacking = false
	# reset animación
	animation.play("lyra_idle")

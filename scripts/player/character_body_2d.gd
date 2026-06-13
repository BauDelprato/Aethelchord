extends CharacterBody2D

@onready var animation = $AnimatedSprite2D
@onready var lyra_health = $HealthManager
@onready var lyra_ability = $AbilityManager
@onready var attackbox = $Attackbox

var is_attacking = false
var facing_right = true

const SPEED = 300.0
const JUMP_VELOCITY = -400.0


func _physics_process(delta):
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
	if Input.is_action_just_pressed("attack") and !is_attacking:
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
	
	# Animaciones de ataque
	if is_attacking:
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

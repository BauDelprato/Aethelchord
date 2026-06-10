extends Node2D
#CLASE MANEJADORA DE HABILIDADES BÁSICAS (ataque, bloqueo y dash)
@onready var Attackbox=$"../Attackbox"
@onready var animation=$"../AnimatedSprite2D"

func attack():

	var player = get_parent()

	player.is_attacking = true

	animation.play("lyra_basic_attack")

	Attackbox.monitoring = true

	await animation.animation_finished

	Attackbox.monitoring = false

	player.is_attacking = false

func dash():
	print("Dash")

func block():
	print("Block")

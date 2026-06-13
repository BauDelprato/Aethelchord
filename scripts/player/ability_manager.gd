extends Node2D
#CLASE MANEJADORA DE HABILIDADES BÁSICAS (ataque, bloqueo y dash)
@onready var Attackbox=$"../Attackbox"
@onready var AttackCollision=$"../Attackbox/CollisionShape2D"
@onready var animation=$"../AnimatedSprite2D"

func attack():

	var player = get_parent() #agarra el nodo padre

	player.is_attacking = true #variable del padre
	
	animation.play("lyra_basic_attack") #display de la animación
	AttackCollision.disabled = false
	Attackbox.monitoring = true
	
	await animation.animation_finished

	Attackbox.monitoring = false
	AttackCollision.disabled = true
	player.is_attacking = false
	print("SE PRODUJO UN ATAQUE DE LYRA")
	

func dash():
	print("Dash")

func block():
	print("Block")

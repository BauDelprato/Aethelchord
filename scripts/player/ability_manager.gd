extends Node2D

var enabled := true

@onready var Attackbox = $"../Attackbox"
@onready var AttackCollision = $"../Attackbox/CollisionShape2D"
@onready var animation = $"../AnimatedSprite2D"

func attack():
	if !enabled:
		return
	
	var player = get_parent()
	
	player.is_attacking = true
	
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

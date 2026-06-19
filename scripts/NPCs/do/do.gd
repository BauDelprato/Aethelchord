extends Node2D

@onready var attackbox = $Attackbox
@onready var attackcollision = $Attackbox/CollisionShape2D
@onready var hurtbox = $Hitbox
@onready var animation = $AnimatedSprite2D
@onready var lyra_position = $"../Lyra"
var is_player_close = false
var is_dialogue_active = false
var taking_damage = false
var do_defeated = false
const lyra_and_do1 = preload("res://resources/dialogues/lyra_and_do.dialogue")
const lyra_and_do2 = preload("res://resources/dialogues/lyra_and_do2.dialogue")
# Called when the node enters the scene tree for the first time.
func _ready():
	hurtbox.monitoring = false #hurtbox desactivada hasta el combate
	

	
	DialogueManager.dialogue_started.connect(_on_dialogue_started)
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)  
	DialogueManager.dialogue_started.connect(_on_dialogue_started2)
	DialogueManager.dialogue_started.connect(_on_dialogue_started2)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_player_close and Input.is_action_just_pressed("interact") and not is_dialogue_active and not do_defeated: 
		print ("INICIO DE DIÁLOGO CON DO")
		DialogueManager.show_dialogue_balloon(lyra_and_do1)
	else :
		if is_player_close and Input.is_action_just_pressed("interact") and do_defeated:
			DialogueManager.show_dialogue_balloon(lyra_and_do2)

	if lyra_position.global_position.x <  global_position.x:
		animation.flip_h = true
		attackbox.position.x = -175
	else:
		animation.flip_h = false
		attackbox.position.x = -1
	
#funcion para actualizar la animación cada frame (no borrar)
func _physics_process(delta):
	if is_instance_valid(hurtbox) and hurtbox.damaged:
		hurtbox.damaged = false
		animation.play("do_take_damage")
	elif animation.animation != "do_take_damage" or not animation.is_playing():
		if not attackcollision.disabled:
			animation.play("do_idle_attack")
		else:
			animation.play("do_idle")

func _on_text_area_area_entered(area):#PARA DIÁLOGOS USAR LAYER NULA MASK 6
	is_player_close = true


func _on_text_area_area_exited(area):
	is_player_close = false
	# Replace with function body.

func _on_dialogue_started(lyra_and_do1):
	lyra_position.set_physics_process(false)
	is_dialogue_active = true

func _on_dialogue_ended(lyra_and_do1):
	lyra_position.set_physics_process(true)
	is_dialogue_active = false
	if not do_defeated : 
		_attack_phase()
	
func _on_dialogue_started2(lyra_and_do2):
	lyra_position.set_physics_process(false)
	is_dialogue_active = true
	pass
	

func _on_dialogue_ended2(lyra_and_do2):
	lyra_position.set_physics_process(true)
	is_dialogue_active = false
	pass
	

func _attack_phase():
	$AttackManager/Timer.start() #Inicia el timer de los ataques en AttackManager
	print("FASE ATAQUE")
	$TextArea.monitoring = false
	hurtbox.monitoring = true
	
	hurtbox.defeated.connect(_on_enemy_defeated)
	
func _on_enemy_defeated():
	print("DO DERROTADO")
	do_defeated = true
	$AttackManager/Timer.stop()
	$TextArea.monitoring = true
	#hurtbox.monitoring = false
	

	
	
	

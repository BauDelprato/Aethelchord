extends Node2D

@onready var attackbox = $Attackbox
@onready var attackcollision = $Attackbox/CollisionShape2D
@onready var hurtbox = $Hitbox
@onready var animation = $AnimatedSprite2D
@onready var lyra_position = $"../Lyra"
@onready var boss_interface = $BossInterface
@onready var ability_manager = $"../Lyra/AbilityManager"

var is_player_close = false
var is_dialogue_active = false
var taking_damage = false
var do_defeated #para la animacion del do
var fight_done #para q el dialogo no se repita
var alcantarillas_unblocked = false #para habilitar alcantarillas dsp del dialogo
const lyra_and_do1 = preload("res://resources/dialogues/lyra_and_do.dialogue")
const lyra_and_do2 = preload("res://resources/dialogues/lyra_and_do2.dialogue")
# Called when the node enters the scene tree for the first time.
func _ready():
	boss_interface.hide()
	hurtbox.monitoring = false #hurtbox desactivada hasta el combate
	
	DialogueManager.dialogue_started.connect(_on_dialogue_started)
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if lyra_position.global_position.x <  global_position.x:
		animation.flip_h = true
		attackbox.position.x = -175
	else:
		animation.flip_h = false
		attackbox.position.x = -1

func _unhandled_input(event):#solo se ejecuta si el diálogo no consumió el botón primero
	if event.is_action_pressed("interact") and is_player_close and not is_dialogue_active:
		if not fight_done:
			DialogueManager.show_dialogue_balloon(lyra_and_do1)
		else:
			DialogueManager.show_dialogue_balloon(lyra_and_do2)

#funcion para actualizar la animación cada frame (no borrar)
func _physics_process(delta):
	if is_instance_valid(hurtbox) and hurtbox.damaged:
		hurtbox.damaged = false
		animation.play("do_take_damage")
	elif animation.animation != "do_take_damage" or not animation.is_playing():
		if not attackcollision.disabled:
			animation.play("do_idle_attack")
		elif do_defeated:
			animation.play("do_defeated")
		else:
			animation.play("do_idle")

func _on_text_area_area_entered(area):#PARA DIÁLOGOS USAR LAYER NULA MASK 6
	is_player_close = true
	if not do_defeated:
		Eventos.mostrar_aviso_interaccion.emit("Toca X para hablar")
	else:
		Eventos.mostrar_aviso_interaccion.emit("Toca X para interactuar")


func _on_text_area_area_exited(area):
	is_player_close = false
	Eventos.ocultar_aviso_interaccion.emit()

func _on_dialogue_started(resource):
	if resource == lyra_and_do1 or resource == lyra_and_do2:
		lyra_position.set_physics_process(false)
		is_dialogue_active = true
		Eventos.ocultar_aviso_interaccion.emit()

func _on_dialogue_ended(resource):
	lyra_position.set_physics_process(true)
	is_dialogue_active = false

	if resource == lyra_and_do1:#hace algo depende de que dialogo termino 
		if not do_defeated: 
			_attack_phase()
	elif resource == lyra_and_do2:
		do_defeated = false
		alcantarillas_unblocked = true
		print("termina la charla")
	
	

func _attack_phase():
	ability_manager.enabled = true
	$AttackManager/Timer.start() #Inicia el timer de los ataques en AttackManager
	print("FASE ATAQUE")
	$TextArea.monitoring = false
	hurtbox.monitoring = true
	boss_interface.show()
	hurtbox.defeated.connect(_on_enemy_defeated)
	
func _on_enemy_defeated():
	print("DO DERROTADO")
	do_defeated = true
	fight_done = true
	$AttackManager/Timer.stop()
	$TextArea.monitoring = true
	#hurtbox.monitoring = false
	
	boss_interface.hide()

	
	
	

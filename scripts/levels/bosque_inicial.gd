extends Node2D

@onready var camara_jugador = $Lyra/Camera2D 

@export var intro_dialogue: DialogueResource 
const GloboArriba = preload("res://resources/dialogues/balloon.tscn")

#limites de camara
@export_category("Scene Limits")
@export var limit_left: int = -1
@export var limit_right: int = 8109
@export var limit_top: int = -16
@export var limit_bottom: int = 600


func _ready():
	camara_jugador.limit_left = limit_left
	camara_jugador.limit_right = limit_right
	camara_jugador.limit_top = limit_top
	camara_jugador.limit_bottom = limit_bottom
	

func _on_trigger_intro_body_entered(body):
	if body.name == "Lyra":
		var globo = GloboArriba.instantiate()
		add_child(globo)
		globo.start(intro_dialogue, "start")
		$triggerIntro.queue_free()

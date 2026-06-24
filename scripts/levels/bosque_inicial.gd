extends Node2D


@export var intro_dialogue: DialogueResource 

#limites de camara
@export_category("Scene Limits")
@export var limit_left: int = -60
@export var limit_right: int = 8100
@export var limit_top: int = -20
@export var limit_bottom: int = 600

const GloboArriba = preload("res://resources/dialogues/balloon_top.tscn")

func _ready():
	$Lyra/AbilityManager.enabled = false #DESACTIVA el ataque, llamar a enabled = false para desactivar
	

func _on_trigger_intro_body_entered(body):
	if body.name == "Lyra":
		var globo = GloboArriba.instantiate()
		add_child(globo)
		globo.start(intro_dialogue, "start")
		$triggerIntro.queue_free()

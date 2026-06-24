extends Node2D

@export var intro_dialogue: DialogueResource 
const GloboArriba = preload("res://resources/dialogues/balloon.tscn")

func _ready():
	pass # etc

func _on_trigger_intro_body_entered(body):
	if body.name == "Lyra":
		var globo = GloboArriba.instantiate()
		add_child(globo)
		globo.start(intro_dialogue, "start")
		$triggerIntro.queue_free()

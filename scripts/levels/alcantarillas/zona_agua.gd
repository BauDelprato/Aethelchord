extends Area2D
@onready var lyra: CharacterBody2D = $"../Lyra"

func _on_body_entered(body):
	if body.name == "Lyra": 
		lyra._on_lyra_died()

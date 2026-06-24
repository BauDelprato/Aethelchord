extends Area2D

var lyra_en_rango = false

func _on_body_entered(body):
	if body.name == "Lyra": 
		lyra_en_rango = true
		Eventos.mostrar_aviso_interaccion.emit("Toca X para interactuar")

func _on_body_exited(body):
	if body.name == "Lyra":
		lyra_en_rango = false
	   
		Eventos.ocultar_aviso_interaccion.emit()

func _unhandled_input(event):
	if lyra_en_rango and event.is_action_pressed("interact"):
		get_tree().change_scene_to_file("res://sidequests/miniJuegoRitmo/scenes/Game.tscn")

extends Area2D

var lyra_en_rango = false
@onready var do: Node2D = $"../Do"

func _on_body_entered(body):
	if body.name == "Lyra": 
		lyra_en_rango = true
		if do.alcantarillas_unblocked:
			Eventos.mostrar_aviso_interaccion.emit("Toca 'X' para entrar")

func _on_body_exited(body):
	if body.name == "Lyra":
		lyra_en_rango = false
	   
		Eventos.ocultar_aviso_interaccion.emit()

func _unhandled_input(event):
	if do.alcantarillas_unblocked and lyra_en_rango and event.is_action_pressed("interact"):
		Global.posicion_jugador2 = $"../Lyra".global_position
		get_tree().change_scene_to_file("res://scenes/levels/alcantarilla.tscn")

extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_empezar_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/levels/Bosque_Inicial.tscn") # Replace with function body.


func _on_opciones_pressed() -> void: 
	get_tree().change_scene_to_file("res://scenes/menus/OptionsScreen.tscn") # Replace with function body.


func _on_salir_pressed() -> void:
	get_tree().quit() # Replace with function body.


func _on_mini_juego_pressed() -> void:
	get_tree().change_scene_to_file("res://sidequests/miniJuegoRitmo/scenes/Game.tscn") # Replace with function body.

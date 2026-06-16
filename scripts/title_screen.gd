extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(_delta):
	# Replace with function body.


func _on_empezar_pressed() -> void:
	get_tree().change_scene_to_file("res://Escena_Inicial.tscn") # Replace with function body.


func _on_opciones_pressed() -> void: 
	get_tree().change_scene_to_file("res://scenes/menus/OptionsScreen.tscn") # Replace with function body.


func _on_salir_pressed():
	# Primero verificamos que el nodo esté conectado al árbol del juego
	if get_tree() != null:
		get_tree().quit()
	else:
		print("Error: El nodo no está en el SceneTree, pero el juego se cerrará igual.")


func _on_minijuego_pressed() -> void:
	get_tree().change_scene_to_file("res://miniJuego/scenes/Game.tscn")

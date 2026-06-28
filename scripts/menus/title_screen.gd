extends Control

@onready var title: TextureRect = $Title
@onready var button_manager: Control = $Button_manager
@onready var options: Panel = $OptionsPanel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	title.visible = true
	button_manager.visible = true
	options.visible = false
	options.back_pressed.connect(_on_options_back)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_empezar_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/levels/Bosque_Inicial.tscn") # Replace with function body.


func _on_opciones_pressed() -> void: 
	title.visible = false
	button_manager.visible = false
	options.visible = true
	


func _on_salir_pressed() -> void:
	get_tree().quit() # Replace with function body.


func _on_mini_juego_pressed() -> void:
	get_tree().change_scene_to_file("res://sidequests/miniJuegoRitmo/scenes/Game.tscn") # Replace with function body.


func _on_options_back():
	options.hide()
	title.show()
	button_manager.show()

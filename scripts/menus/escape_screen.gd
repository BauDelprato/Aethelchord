extends CanvasLayer

@onready var options_panel: Panel = $OptionsPanel
@onready var v_box_container_2: VBoxContainer = $VBoxContainer2

var paused := false

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS

	hide()
	options_panel.hide()

	options_panel.back_pressed.connect(_on_options_back)

func _input(event):
	if event.is_action_pressed("pause"):
		if paused:
			resume()
		else:
			pause()

func pause():
	show()
	options_panel.hide()

	get_tree().paused = true
	paused = true

func resume():
	hide()

	get_tree().paused = false
	paused = false

func _on_continue_pressed():
	resume()

func _on_options_pressed():
	v_box_container_2.hide()
	options_panel.show()

func _on_exit_pressed():
	resume()
	get_tree().change_scene_to_file("res://scenes/menus/titleScreen.tscn")

func _on_options_back():
	options_panel.hide()
	v_box_container_2.show()

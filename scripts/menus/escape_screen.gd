extends CanvasLayer

var paused := false

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS #nodo está funcionando todo el tiempo
	hide()

func _input(event):
	if event.is_action_pressed("pause"):
		if paused:
			resume()
		else:
			pause()

func pause():
	show()
	get_tree().paused = true
	paused = true

func resume():
	hide()
	get_tree().paused = false
	paused = false

func _on_continue_pressed():
	resume()

func _on_options_pressed():
	get_tree().paused = false
	paused = false
	get_tree().change_scene_to_file("res://scenes/menus/options.tscn")

func _on_exit_pressed():
	get_tree().paused = false
	paused = false
	get_tree().change_scene_to_file("res://scenes/menus/titleScreen.tscn")

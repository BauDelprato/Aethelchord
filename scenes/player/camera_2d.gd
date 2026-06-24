extends Camera2D


# Called when the node enters the scene tree for the first time.



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var current_scene = get_tree().current_scene
	
	if current_scene and "limit_left" in current_scene:
		limit_left = current_scene.limit_left 
		limit_right = current_scene.limit_right 
		limit_top = current_scene.limit_top
		limit_bottom = current_scene.limit_bottom 

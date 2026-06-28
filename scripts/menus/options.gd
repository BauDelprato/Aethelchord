extends Panel

signal back_pressed

func _ready():
	hide()

func _on_atras_button_pressed():
	back_pressed.emit()

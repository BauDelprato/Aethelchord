extends CanvasLayer

@onready var cartel_interaccion = $Control/Label 

func _ready():
	Eventos.mostrar_aviso_interaccion.connect(_on_mostrar_aviso)
	Eventos.ocultar_aviso_interaccion.connect(_on_ocultar_aviso)

func _on_mostrar_aviso(texto_personalizado: String):
	cartel_interaccion.text = texto_personalizado
	cartel_interaccion.visible = true

func _on_ocultar_aviso():
	cartel_interaccion.visible = false

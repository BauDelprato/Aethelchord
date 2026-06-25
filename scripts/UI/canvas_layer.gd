extends CanvasLayer

@onready var barra_vida = $ProgressBar
@onready var player = get_tree().get_first_node_in_group("player")
@onready var health_manager = player.get_node("HealthManager")

func _ready():
	barra_vida.max_value = health_manager.max_health
	barra_vida.value = health_manager.current_health

	health_manager.health_changed.connect(_on_health_changed)

func _on_health_changed(current):
	barra_vida.value = current

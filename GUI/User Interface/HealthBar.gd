extends ColorRect

@onready var health_bar = $HealthBar

func update_health(health, max_health) -> void:
	health_bar.size.x = 196 * health / max_health

extends StaticBody2D

@export var health: int = 100

func take_damage(damage: int) -> void:
	health -= damage
	print("current health: ", health)
	if health <= 0:
		queue_free()

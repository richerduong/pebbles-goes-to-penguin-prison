extends StaticBody2D

@export var health: int = 100
@export var pickup_type : PackedScene

@onready var level_parent = get_parent()

# Hit Flash Shader
@onready var sprite = $Sprite2D
@onready var flashTimer = $FlashHitTimer

func take_damage(damage: int) -> void:
	health -= damage
	flash()
	print("current health: ", health)
	if health <= 0:
		queue_free()
		spawn_resource()

func flash():
	if sprite and sprite.material:
		sprite.material.set_shader_parameter("flash_modifier", 0.7)
		flashTimer.start()

func _on_FlashTimer_timeout():
	sprite.material.set_shader_parameter("flash_modifier", 0)

func spawn_resource():
	var pickup_instance : Pickup = pickup_type.instantiate() as Pickup
	level_parent.add_child(pickup_instance)
	pickup_instance.position = position

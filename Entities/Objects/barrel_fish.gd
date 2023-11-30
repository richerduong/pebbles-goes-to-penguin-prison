extends StaticBody2D

@export var health: int = 100

#Fish Drops
@export var pickup_type : PackedScene
@onready var level_parent = get_parent()
@export var launch_speed : float = 35
@export var launch_direction : float = 0.25

#Hit Flash Shader
@onready var sprite = $Sprite2D
@onready var flashTimer = $FlashHitTimer

@onready var barrelbreak = $barrelbreak

func take_damage() -> void:
	health -= 50
	flash()
	
	#print("current health: ", health)
	if health <= 0:
		barrelbreak.play()
		spawn_resource()
		$CollisionShape2D.set_deferred("disabled", true)
		sprite.visible = false
		await get_tree().create_timer(1.36).timeout
		queue_free()

func spawn_resource():
	var pickup_instance : Pickup = pickup_type.instantiate() as Pickup
	level_parent.add_child(pickup_instance)
	pickup_instance.position = position

	var direction : Vector2 = Vector2 (
		randf_range(-1.0, 1.0),
		randf_range(-1.0, 1.0)
	).normalized()

	pickup_instance.launch(direction * launch_speed, launch_direction)

func flash():
	if sprite and sprite.material:
		sprite.material.set_shader_parameter("flash_modifier", 0.7)
		flashTimer.start()

func _on_FlashHitTimer_timeout():
	sprite.material.set_shader_parameter("flash_modifier", 0)

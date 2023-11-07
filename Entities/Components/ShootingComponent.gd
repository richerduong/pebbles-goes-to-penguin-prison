extends Node2D
class_name ShootingComponent

@export var entity_sprite: Sprite2D
@export var gun: Gun

var can_shoot: bool = true

func show_gun():
	gun.visible = true

func hide_gun():
	gun.visible = false

func aim(body: CharacterBody2D):
	if body != null:
		var aim_rotation = gun.aim(body.global_position)
		if aim_rotation < PI/2 and aim_rotation > -PI/2:
			entity_sprite.flip_h = false # right
		else:
			entity_sprite.flip_h = true # left

func shoot():
	if can_shoot: 
		gun.shoot()
		can_shoot = false
		get_tree().create_timer(gun.inventory_item.shooter.firerate).connect("timeout", _enable_can_shoot)

func _enable_can_shoot() -> void:
	can_shoot = true

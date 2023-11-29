extends Sprite2D

class_name Gun

@onready var bullet_trail_scene: PackedScene = preload("res://Guns/Bullets/bullet_trail.tscn")
@export var inventory_item: InventoryItem

@export var bulletSpeed: float = 800

func _ready():
	position.y = position.y + 7
	offset.x = 7
	update_texture()

func update_texture() -> void:
	if inventory_item: 
		texture = inventory_item.texture
	else:
		texture = null

func aim(target: Vector2) -> float:
	look_at(target)
	rotation = wrapf(rotation, -PI, PI)
	if rotation < PI/2 and rotation > -PI/2:
		flip_v = false # right
	else:
		flip_v = true # left
	return rotation

func get_type():
	if inventory_item and inventory_item.shooter:
		return inventory_item.shooter.type()

func shoot() -> bool:
	if inventory_item and inventory_item.shooter: 
		_muzzle_flash()
		var room_node = get_node("/root/World/RoomManager/Room")
		var bullets = inventory_item.shooter.shoot() as Array[Bullet]
#		if World.INPUT_SCHEME == World.INPUT_SCHEMES.GAMEPAD:
#			Input.start_joy_vibration(0, .1, 0, .25)
		if bullets.size():
			for bullet in bullets:
				bullet.rotation += rotation
				bullet.global_position = global_position + Vector2(0, inventory_item.muzzle.y)
				bullet.global_position = global_position + (Vector2.RIGHT * inventory_item.muzzle.x).rotated(rotation)
				
				var bullet_trail = bullet_trail_scene.instantiate() as BulletTrail
				bullet_trail.bullet_scene = bullet
				
				bullet.speed = bulletSpeed
				
				room_node.add_child(bullet)
				room_node.add_child(bullet_trail)
			return true
	return false

func _muzzle_flash() -> void:
	$MuzzleFlash.energy = 0.5
	get_tree().create_timer(0.06).connect("timeout", _muzzle_flash_timeout)

func _muzzle_flash_timeout() -> void:
	$MuzzleFlash.energy = 0

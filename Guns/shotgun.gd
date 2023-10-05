extends Sprite2D

@onready var muzzle: Node2D = $Muzzle

@export var user: CharacterBody2D
@export var bullet_scene: PackedScene

var _target: Vector2

func _physics_process(_delta):
	rotation = __wrap(rotation)
	__flip_gun()

func __wrap(angle: float) -> float:
	if angle < 0:
		return angle + 2 * PI
	elif angle > 2 * PI:
		return angle - 2 * PI
	else:
		return angle

func aim_at(target: Vector2) -> void:
	_target = target
	look_at(target)

func shoot() -> void:
	var bullet1: Area2D = bullet_scene.instantiate()
	var bullet2: Area2D = bullet_scene.instantiate()
	var bullet3: Area2D = bullet_scene.instantiate()
	
	bullet1.global_position = muzzle.global_position
	bullet2.global_position = muzzle.global_position
	bullet3.global_position = muzzle.global_position
	
	bullet1.look_at(_target)
	bullet2.look_at(_target)
	bullet3.look_at(_target)
	
	bullet1.rotation = rotation + 0.1
	bullet2.rotation = rotation
	bullet3.rotation = rotation + -0.1
	
	user.owner.add_child(bullet1)
	user.owner.add_child(bullet2)
	user.owner.add_child(bullet3)


func __flip_gun():
	if rotation > 3 * PI / 2 or rotation < PI / 2:
		flip_v = false
	else:
		flip_v = true

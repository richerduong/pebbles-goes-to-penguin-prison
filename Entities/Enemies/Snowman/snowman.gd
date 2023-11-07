extends CharacterBody2D

const bullet_scene = preload("res://Entities/Enemies/Snowman/snowball.tscn")
@onready var shoot_timer = $ShootTimer
@onready var rotater = $Rotater

const rotate_speed = 100
const shooter_timer_wait_time = 0.2
const spawn_point_count = 4
const radius = 100

#############

var speed = 25
var player_chase = false
var player = null

	
func _ready():
	var step = 2 * PI / spawn_point_count
	for i in range(spawn_point_count):
		var spawn_point = Node2D.new()
		var pos = Vector2(radius, 0).rotated(step * 1)
		spawn_point.position = pos
		spawn_point.rotation = pos.angle()
		rotater.add_child(spawn_point)
		
	shoot_timer.wait_time = shooter_timer_wait_time
	shoot_timer.start()

func _process(delta: float) -> void:
	var new_rotation = rotater.rotation_degrees + rotate_speed * delta
	rotater.rotation_degrees = fmod(new_rotation, 360)

func _on_shoot_timer_timeout():
	for s in rotater.get_children():
		var bullet = bullet_scene.instantiate()
		get_tree().get_root().add_child(bullet)
		bullet.position = s.global_position
		bullet.rotation = s.global_rotation

func _physics_process(delta):
	if player_chase:
		position += (player.position - position)/speed


func _on_detection_area_body_entered(body):
	player = body
	player_chase = true


func _on_detection_area_body_exited(body):
	player = null
	player_chase = false

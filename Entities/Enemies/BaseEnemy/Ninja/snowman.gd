extends CharacterBody2D

const snowball_scene = preload("res://Entities/Enemies/BaseEnemy/Ninja/snowball.tscn")
const starReturn_scene = preload("res://Entities/Enemies/BaseEnemy/Ninja/starReturn.tscn") # Load the starReturn scene
@onready var shoot_timer = $ShootTimer
@onready var rotater = $Rotater
@onready var shurikenSound = $shurikenSound

const rotate_speed = 200
const shooter_timer_wait_time = 0.001
const spawn_point_count = 24
const radius = 25

var player # The player reference

func _ready():
#	player = get_tree().get_nodes_in_group("player")[0] # Assign the player reference
	var player_nodes = get_tree().get_nodes_in_group("player")
	if player_nodes.size() > 0:
		player = player_nodes[0]
	else:
		print("No player nodes found in 'player' group.")
		# Handle the absence of player nodes appropriately, possibly with a fallback or error handling.

	_shoot()

func _process(delta: float) -> void:
	var new_rotation = rotater.rotation_degrees + rotate_speed * delta
	rotater.rotation_degrees = fmod(new_rotation, 360)

func _shoot():
	var step = 2 * PI / spawn_point_count
	for i in range(spawn_point_count):
		var spawn_point = Node2D.new()
		var pos = Vector2(radius, 0).rotated(step * 1)
		spawn_point.position = pos
		spawn_point.rotation = pos.angle()
		rotater.add_child(spawn_point)

	# # of spirals we want to create
	for i in range(3):
		for s in rotater.get_children():
			shurikenSound.play()
			await get_tree().create_timer(0.2).timeout
			var bullet = snowball_scene.instantiate()
			get_tree().get_root().add_child(bullet)
			bullet.position = s.global_position
			bullet.rotation = s.global_rotation

	# waiting for 5 seconds before shooting again
	await get_tree().create_timer(3).timeout
	_shootOne()
	await get_tree().create_timer(3).timeout
	_shoot()

func _shootOne():
	print("shooting three")
	# Shoot three starReturn at the playervar angle = angle_to_player() # Get the angle to the player
	for i in range(5):
		var angle = angle_to_player() # Get the angle to the player
		var star = starReturn_scene.instantiate() # Instantiate a starReturn
		get_tree().get_root().add_child(star) # Add it to the root
		star.position = position # Set its position to the snowman's position
		star.rotation = angle + randf_range(-0.1, 0.1) # Set its rotation to the angle plus some random variation
		star.snowman = self # Pass the snowman reference to the starReturn
		star.direction = star.transform.x # Pass the original direction to the starReturn
		await get_tree().create_timer(0.4).timeout

func angle_to_player():
	if player == null:
		print("Player reference is null.")
		return 0  # Return a default value or handle this case appropriately.

	# Calculate the angle between the snowman and the player
	var diff = player.position - position # Get the difference vector
	return atan2(diff.y, diff.x) # Return the angle using atan2


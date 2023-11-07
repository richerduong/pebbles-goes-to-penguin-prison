#extends Resource
#
#@export var recoil: float = 0  # Lasers typically don't have recoil
#@export var firerate: float = 0.08  # How often the laser can be "pulsed"
#
#var laser_scene: PackedScene = load("res://Guns/Effects/laser_beam.tscn")  # Laser beam scene
#
#func shoot() -> Array[Bullet]:
#	var beams: Array[Bullet] = []  # This will hold the laser beam instances
#	var beam = laser_scene.instantiate()  # Create an instance of the laser
#
#	# Set up the beam properties, such as its position and direction
#	# ...
#
#	beams.append(beam)
#	return beams
#
## Since `type` is not a built-in method, let's rename it to avoid confusion
#func get_weapon_type():
#	return "lasergun"
#
## Add more functions here specific to how a laser beam would work,
## such as updating its length, position, and checking for collisions

extends Resource

@export var recoil: float = 0  # Lasers typically don't have recoil
@export var firerate: float = 0.08  # How often the laser can be "pulsed"

var laser_scene: PackedScene = preload("res://Guns/Bullets/Effects/laser_beam.tscn")  # Preload the laser beam scene

func shoot(start_position: Vector2, direction: Vector2) -> void:
	var beam = laser_scene.instantiate() as RayCast2D  # Make sure to cast to the correct type
	beam.global_position = start_position  # Position the beam at the shooting point
	beam.rotation = direction.angle()  # Rotate the beam towards the shooting direction
	beam.is_casting = true  # Start the beam casting
	
	# Then, add the beam to the scene tree. Assuming you have a reference to your main game node:
	var main_game_node = get_node(".")  # Change the path to your main game node
	main_game_node.add_child(beam)
	
	# You could set a timer to stop the beam after a certain duration
	var timer = Timer.new()
	beam.add_child(timer)
	timer.wait_time = 2.0  # Duration in seconds for how long the beam lasts
	timer.one_shot = true
	timer.connect("timeout", beam, "set_is_casting", [false])
	timer.start()

func get_weapon_type() -> String:
	return "lasergun"

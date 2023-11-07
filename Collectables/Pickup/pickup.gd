extends Area2D

class_name Pickup

@export var resource_type : Resource
@onready var collision_shape : CollisionShape2D = $CollisionShape2D

func _ready():
	connect("body_entered", _on_body_entered)

var launch_velocity : Vector2 = Vector2.ZERO
var move_duration : float = 0
var time_since_launch : float = 0
var launching : bool = false :
	set(is_launching): 
		launching = is_launching
		collision_shape.disabled = launching

func _process(delta):
	if (launching):
		position += launch_velocity * delta
		time_since_launch += delta
		
		if (time_since_launch >= move_duration):
			launching = false

func launch(velocity : Vector2, duration : float):
	launch_velocity = velocity
	move_duration = duration
	time_since_launch = 0
	launching = true

func _on_body_entered(body):
	var inventory = body.find_child("Fishventory")
	
	if (inventory):
		inventory.add_resources(resource_type, 1)
		print("Collected fish! Total fish: ", inventory.get_fish_value())
		queue_free()

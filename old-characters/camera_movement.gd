extends Camera2D

@export var move_weight: float = 0.15
@export var target: Node2D

func _init():
	position = Vector2i.ZERO

func _physics_process(_delta):
	var new_position: Vector2i = lerp(position, target.position, move_weight)
	position = new_position

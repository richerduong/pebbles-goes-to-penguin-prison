extends RayCast2D

#var tween := Tween.new() # Create a new Tween instance

var is_casting: bool = false:
	set(value):
		is_casting = value
		set_physics_process(value)

func _ready() -> void:
	set_physics_process(false)
	$Line2D.points[1] = Vector2.ZERO

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		self.is_casting = event.pressed

func _physics_process(delta: float) -> void:
	var cast_point := target_position
	force_raycast_update()

	if is_colliding():
		cast_point = to_local(get_collision_point())

	$Line2D.points[1] = cast_point

func set_is_casting(value: bool) -> void:
	is_casting = value
#	if is_casting:
#		appear()
#	else:
#		disappear()
	set_physics_process(value)
	

#func appear() -> void:
#	tween.stop_all() # Stop all previous tweens.
#	tween.interpolate_property($Line2D, "width", 0, 10.0, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
#	tween.start() # Start the tween.
#
#func disappear() -> void:
#	tween.stop_all() # Stop all previous tweens.
#	tween.interpolate_property($Line2D, "width", 10.0, 0, 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
#	tween.start() # Start the tween.


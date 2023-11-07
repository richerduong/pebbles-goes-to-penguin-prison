extends State

@export var movement_component: MovementComponent
@export var health_component: HealthComponent
@export var sight_radius: Area2D

var _idling: bool = false

func pause_wander():
	movement_component.stop_movement()
	get_tree().create_timer(randf_range(1,2)).connect("timeout", random_wander)

func random_wander():
	if !_idling: return
	if health_component.is_dead(): 
		movement_component.stop_movement()
		return
	var move_direction = Vector2(randf_range(-1,1), randf_range(-1,1)).normalized()
	movement_component.set_movement_direction(move_direction)
	get_tree().create_timer(randf_range(1,2)).connect("timeout", pause_wander)

func physics_update(delta: float):
	if health_component.has_taken_damage():
		target = get_node("/root/World/RoomManager/Pebbles")
		_idling = false
		Transitioned.emit(self, "Follow")

func enter():
	_idling = true
	movement_component.walking = true
	sight_radius.connect("body_entered", _is_pebbles)
	get_tree().create_timer(1).connect("timeout", _enable_sight)
	random_wander()

func _is_pebbles(body) -> void:
	if body.name == "Pebbles":
		target = body
		_idling = false
		Transitioned.emit(self, "Follow")

func _enable_sight() -> void:
	sight_radius.monitoring = true

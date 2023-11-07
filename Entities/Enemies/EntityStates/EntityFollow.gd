extends State

@onready var navigation_timer: Timer = $NavigationTimer

@export var entity_node: CharacterBody2D
@export var movement_component: MovementComponent
@export var health_component: HealthComponent
@export var sight_radius: Area2D
@export var navigation_node: NavigationAgent2D
@export var engage_distance: float = 100

var _following: bool = false

func enter():
	_following = true
	movement_component.stop_movement()
	movement_component.walking = false
	for body in sight_radius.get_overlapping_bodies():
		if body.name == "Pebbles":
			target = body
	if !target:
		Transitioned.emit(self, "Idle")
	else:
		navigation_node.path_desired_distance = 4
		navigation_node.target_desired_distance = 4
		call_deferred("_actor_setup")

func physics_update(_delta: float):
	var distance_to_target = target.global_position.distance_to(entity_node.global_position)
	if distance_to_target < engage_distance:
		_following = false
		navigation_timer.stop()
		movement_component.stop_movement()
		Transitioned.emit(self, "Engage")
	
	if navigation_node.is_navigation_finished() or health_component.is_dead():
		navigation_timer.stop()
		movement_component.stop_movement()

func _actor_setup() -> void:
	await get_tree().physics_frame
	navigation_timer.start()
	set_movement_target(target.global_position)

func set_movement_target(target_position: Vector2) -> void:
	navigation_node.target_position = target_position

func _on_navigation_timer_timeout():
	if !_following: return
	set_movement_target(target.global_position)
	var current_position = entity_node.global_position
	var next_position = navigation_node.get_next_path_position()
	var direction = next_position - current_position
	movement_component.set_movement_direction(direction)
	

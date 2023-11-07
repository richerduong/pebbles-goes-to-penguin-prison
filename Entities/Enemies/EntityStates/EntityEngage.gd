extends State

@export var entity_node: CharacterBody2D
@export var movement_component: MovementComponent
@export var health_component: HealthComponent
@export var shooting_component: ShootingComponent
@export var disengage_distance: float = 135

var _engaging: bool = false

func enter():
	shooting_component.show_gun()
	_engaging = true

func physics_update(_delta: float):
	if _engaging:
		check_if_too_far()
		if health_component.is_dead(): 
			_engaging = false
			shooting_component.hide_gun()
		else:
			shooting_component.aim(target)
			shooting_component.shoot()
		

func check_if_too_far() -> void:
	var distance_to_target = target.global_position.distance_to(entity_node.global_position)
	if distance_to_target > disengage_distance:
		_engaging = false
		shooting_component.hide_gun()
		Transitioned.emit(self, "Follow")

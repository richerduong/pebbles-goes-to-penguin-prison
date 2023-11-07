extends Node
class_name MovementComponent

@export var entity_node: CharacterBody2D
@export var entity_sprite_node: Sprite2D
@export var animation_tree: AnimationTree
@export var speed: float = 60
@export var knockback_effect: float = 250
@export var knockback_recovery: float = 0.4

var walking: bool = false
var _curr_direction: Vector2
var _stopped: bool = true
var _last_knockback_rotation = 0
var _current_knockback_strength: float = 0

func _physics_process(_delta):
	if _stopped: stop_movement()
	else: set_movement_direction(_curr_direction)
	var _knockback = Vector2.RIGHT.rotated(_last_knockback_rotation) * _current_knockback_strength
	entity_node.velocity += _knockback
	_current_knockback_strength *= knockback_recovery
	entity_node.move_and_slide()

func set_movement_direction(direction: Vector2) -> void:
	_stopped = false
	_curr_direction = direction
	
	entity_node.velocity = direction.normalized() * speed
	if walking: entity_node.velocity /= 4
	
	if direction.x < 0: entity_sprite_node.flip_h = true
	else: 				entity_sprite_node.flip_h = false
	
	animation_tree["parameters/conditions/is_running"] = true
	animation_tree["parameters/conditions/not_running"] = false

func stop_movement() -> void:
	_stopped = true
	entity_node.velocity = Vector2(0,0)
	animation_tree["parameters/conditions/is_running"] = false
	animation_tree["parameters/conditions/not_running"] = true

func knockback(rotation: float) -> void:
	_last_knockback_rotation = rotation
	_current_knockback_strength = knockback_effect

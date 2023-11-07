extends Node
class_name HealthComponent

@export var entity_node: CharacterBody2D
@export var entity_sprite_node: Sprite2D
@export var movement_component: MovementComponent
@export var animation_tree: AnimationTree
@export var health: float = 100
@export var take_knockback: bool = true
@export var flash_on_hit: bool = true

var _taken_damage: bool = false

func is_dead() -> bool:
	return health <= 0

func take_damage(damage: float, rotation: float) -> void:
	_taken_damage = true
	health -= damage
	if take_knockback:
		movement_component.knockback(rotation)
	if flash_on_hit:
		flash()
	if health < 0:
		_death()

func has_taken_damage() -> bool:
	return _taken_damage

func flash() -> void:
	get_tree().create_timer(0.15).connect("timeout", _flash_callback)
	entity_sprite_node.material.set_shader_parameter("flash_modifier", 0.9)

func _flash_callback() -> void:
	entity_sprite_node.material.set_shader_parameter("flash_modifier", 0)

func _death() -> void:
	animation_tree["parameters/conditions/dead"] = true
	entity_node.get_node("Hitbox").queue_free()
	get_tree().create_timer(2).connect("timeout", _death_callback)

func _death_callback() -> void:
	entity_node.queue_free()

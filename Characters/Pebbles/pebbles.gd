extends CharacterBody2D

@export var max_health: int = 100
@export var health: int = max_health
@export var move_speed: float = 250
@export var sprite_2d: Sprite2D
@export var animation_tree: AnimationTree
@export var bullet_scene: PackedScene

const LEFT = Vector2(-1, 1)
const RIGHT = Vector2(1 ,1)
const FLOAT_TOL = 0.001

signal health_update

func _start():
	health_update.emit(health, max_health)

func _physics_process(_delta):
	var horizontal_movement = \
		Input.get_action_strength("right") - \
		Input.get_action_strength("left")
	var vertical_movement = \
		Input.get_action_strength("down") - \
		Input.get_action_strength("up")
	
	var direction = Vector2(
		horizontal_movement, 
		vertical_movement
	).normalized()
	
	velocity = direction * move_speed
	
	move_and_slide()
	pick_new_animation_state()
	
	if Input.is_action_just_pressed("shoot"):
		shoot()
	
	if Input.is_action_just_pressed("ui_text_backspace"):
		take_damage(10)

func pick_new_animation_state():
	if abs(velocity.x) < FLOAT_TOL && abs(velocity.y) < FLOAT_TOL:
		animation_tree["parameters/conditions/not_moving"] = true
		animation_tree["parameters/conditions/moving"] = false
	else:
		animation_tree["parameters/conditions/not_moving"] = false
		animation_tree["parameters/conditions/moving"] = true

func shoot():
	var bullet = bullet_scene.instantiate()
	bullet.global_position = get_node("Gun/Muzzle").global_position
	bullet.rotation = get_node("Gun").rotation
	owner.add_child(bullet)


func take_damage(damage: int) -> void:
	health -= damage
	if health <= 0:
		health = 0
		print("dead")
	health_update.emit(health, max_health)

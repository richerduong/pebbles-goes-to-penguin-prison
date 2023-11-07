extends CharacterBody2D

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var camera: Camera2D = $Camera2D
@onready var gun: Gun = $Gun
@onready var character_sprite: Sprite2D = $PebblesSprite
@onready var ranged_attack_component: Node = $RangedAttackComponent
@onready var inventory_node: Node = $Inventory
@onready var movement_particles: GPUParticles2D = $MovementParticles

@export var speed: float = 200

var collectables: Array[Area2D]

func _physics_process(_delta):
	update_animation()
	handle_player_movement()
	handle_player_shoot()
	handle_player_interactions()
	move_and_slide()

func handle_player_shoot() -> void:
	gun.aim(get_global_mouse_position())
	
	if Input.is_action_pressed("shoot"):
		var current_gun = inventory_node.get_selected_gun()
		if current_gun:
			ranged_attack_component.set_fire_rate(current_gun.shooter.firerate)
			var has_shot = ranged_attack_component.shoot()
			if has_shot: 
				camera.shake(current_gun.shooter.recoil, 0.05)

func handle_player_movement() -> void:
	var movement_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = movement_direction * speed
	movement_particles.emitting = true if velocity else false
	var angle_to_mouse = get_angle_to(get_global_mouse_position())
	if angle_to_mouse < PI/2 and angle_to_mouse > -PI/2:
		character_sprite.flip_h = false # right
	else:
		character_sprite.flip_h = true # left

func handle_player_interactions() -> void:
	# pickup gun
	if collectables.size() and Input.is_action_just_pressed("interact"):
		if !inventory_node.is_full(): 
			inventory_node.insert_gun(collectables.pop_back().collect())
	
	# drop gun
	if Input.is_action_just_pressed("drop gun"):
		var dropped_gun_item = inventory_node.drop_gun()
		if dropped_gun_item:
			var dropped_gun_collectable = load(dropped_gun_item.path_to_collectable_scene).instantiate()
			dropped_gun_collectable.inventory_item = dropped_gun_item
			dropped_gun_collectable.position = position
			dropped_gun_collectable.update()
			
			var room = get_node("/root/World/RoomManager/Room")
			room.add_child(dropped_gun_collectable)
	
	# scroll through inventory
	if Input.is_action_just_pressed("scroll up"):
		inventory_node.scroll_up()
	if Input.is_action_just_pressed("scroll down"):
		inventory_node.scroll_down()
	
	# dashing
	if Input.is_action_just_pressed("dash"):
		dash()

func update_animation() -> void:
	match velocity:
		Vector2.ZERO:
			animation_tree["parameters/conditions/is_running"] = false
			animation_tree["parameters/conditions/is_not_running"] = true
		_:
			animation_tree["parameters/conditions/is_running"] = true
			animation_tree["parameters/conditions/is_not_running"] = false

func _on_pickup_area_area_entered(area):
	if area.has_method("collect"): 
		collectables.append(area)

func _on_pickup_area_area_exited(area):
	if collectables.size() and area == collectables[collectables.size()-1]:
		collectables.pop_back()
		
func dash():
	speed *= 2
	await get_tree().create_timer(0.15).timeout
	speed /= 2

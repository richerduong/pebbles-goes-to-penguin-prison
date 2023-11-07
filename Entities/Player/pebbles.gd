extends CharacterBody2D

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var camera: Camera2D = $Camera2D
@onready var gun: Gun = $Gun
@onready var character_sprite: Sprite2D = $PebblesSprite
@onready var ranged_attack_component: Node = $RangedAttackComponent
@onready var inventory_node: Node = $Inventory
@onready var movement_particles: GPUParticles2D = $MovementParticles

# Audio
@onready var reload = $reload
@onready var pickup = $pickup
@onready var shotgunShot = $shotgunShot
@onready var revolverShot = $revolverShot
@onready var machinegunShot = $machinegunShot
@onready var walkSound = $walkSound
@onready var slideSound = $slideSound

# Health
@onready var fishventory = $Fishventory
@export var max_health: int = 10
@onready var health: int = max_health
var is_eating = false

@export var speed: float = 200
var current_animation: String = "idle"
var is_sliding = false 

var collectables: Array[Area2D]

func _ready():
	animation_tree.active = true

func _physics_process(_delta):
	update_animation()
	handle_player_movement()
	handle_player_shoot()
	handle_player_interactions()
	move_and_slide()
	if Input.is_action_just_pressed("ui_text_backspace"):
		take_damage(1)

func handle_player_shoot() -> void:
	gun.aim(get_global_mouse_position())
	
	if Input.is_action_pressed("shoot"):
		var current_gun = inventory_node.get_selected_gun()
		if current_gun:
			ranged_attack_component.set_fire_rate(current_gun.shooter.firerate)
			var has_shot = ranged_attack_component.shoot()
			if has_shot: 
				var gunType = ranged_attack_component.get_type()
				if gunType == "shotgun":
					shotgunShot.play()
				elif gunType == "revolver":
					revolverShot.play()
				elif gunType == "machinegun":
					machinegunShot.play()
				camera.shake(current_gun.shooter.recoil, 0.05)

func handle_player_movement() -> void:
	if Input.is_action_just_pressed("left") or Input.is_action_just_pressed("right") or Input.is_action_just_pressed("up") or Input.is_action_just_pressed("down"):
		if $walkTimer.time_left <= 0:
				walkSound.pitch_scale = randf_range(0.8, 1.2)
				walkSound.play()
				$walkTimer.start(0.2)
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
			reload.play()
			pickup.play()
			inventory_node.insert_gun(collectables.pop_back().collect())
	
	# drop gun
	if Input.is_action_just_pressed("drop gun"):
		var dropped_gun_item = inventory_node.drop_gun()
		if dropped_gun_item:
			$dropSound.play()
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
		
	if Input.is_action_pressed("slide") and not is_sliding:
		if not is_sliding:  # Slide action is initiated
			is_sliding = true
			slide()
			slideSound.pitch_scale = randf_range(0.8, 1.2)
			slideSound.play()
	
	# press shift to heal (eat)
	if Input.is_action_just_pressed("eat"):
		if fishventory.get_fish_value() > 0:
			is_eating = true
			heal(25)
			fishventory.eat_resource()
			is_eating = false
			print("Fish left in inventory: ", fishventory.get_fish_value())
		else:
			print("No fish in fishventory! Collect some fish!")

func update_animation() -> void:
	# Make sure we only update the animation if we are not sliding or eating
	if is_sliding or is_eating:
		return

	var anim_state = animation_tree.get("parameters/playback") as AnimationNodeStateMachinePlayback
	# Determine the appropriate animation based on velocity
	if velocity == Vector2.ZERO:
		current_animation = "idle"
	else:
		current_animation = "run"
	
	if anim_state.get_current_node() != current_animation:
		anim_state.travel(current_animation)
	
	animation_tree["parameters/conditions/is_running"] = velocity != Vector2.ZERO
	animation_tree["parameters/conditions/is_not_running"] = velocity == Vector2.ZERO

func _on_pickup_area_area_entered(area):
	if area.has_method("collect"): 
		collectables.append(area)

func _on_pickup_area_area_exited(area):
	if collectables.size() and area == collectables[collectables.size()-1]:
		collectables.pop_back()

func slide():
	speed *= 1.5
	animation_tree.set("parameters/conditions/is_sliding", true)
	var anim_state = animation_tree.get("parameters/playback") as AnimationNodeStateMachinePlayback
	anim_state.travel("slide")
	await get_tree().create_timer(0.25).timeout
	reset_slide()
	
func reset_slide():
	speed /= 1.5
	is_sliding = false
	animation_tree.set("parameters/conditions/is_sliding", false)
	var anim_state = animation_tree.get("parameters/playback") as AnimationNodeStateMachinePlayback
	anim_state.travel(current_animation)

func heal(amount: int):
	animation_tree.set("parameters/conditions/is_eating", true)
	var anim_state = animation_tree.get("parameters/playback") as AnimationNodeStateMachinePlayback
	anim_state.travel("eat")
	health += amount

	if health > max_health:
		health = max_health
	#print("Health is: ", health)

# Added from old-main
#@export var sprite_2d: Sprite2D
@export var damage: int = 1
#@onready var gameOver = $GameOverScreen
@onready var sprite2 = $Sprite2D

var enemy_inattack_range = false
var enemy_attack_cooldown = true

signal health_update
signal pebbles_death
signal pebbles_shoot

func take_damage(damage: int) -> void:
	#damage is only going to be 1 for pebbles 
	health -= 1
	
	#flash()
	#enemy_attack_cooldown = false
	# $attack_cooldown.start()
	if health <= 0:
		health = 0
		#sprite2.material.set_shader_parameter("flash_modifier", 0)
		get_tree().paused = true
		character_sprite.visible = false
		#gameOver.visible = true
		print("dead")
		pebbles_death.emit()
	print(health)
	health_update.emit(health, max_health)


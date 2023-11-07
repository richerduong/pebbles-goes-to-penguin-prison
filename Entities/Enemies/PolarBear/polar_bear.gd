extends "res://Entities/Enemies/enemy_base.gd"
@onready var polarSlap = $polarSlap
@onready var gun_placeholder = $PBGun
var gun_instance: PBGun


var weapon_resources = [
	preload("res://Guns/GunTypes/revolver.tres"),
	preload("res://Guns/GunTypes/shotgun.tres"),
	preload("res://Guns/GunTypes/machinegun.tres"),
	null
	]
var has_gun = false



func _ready():
	randomize()  # Randomize the random number generator
	choose_weapon()

func choose_weapon():
	var weapon_choice_index = randi() % weapon_resources.size()
	if weapon_choice_index >= 0:  # If weapon_choice_index is -1, no weapon is chosen
		has_gun = true
		can_shoot = true
		instantiate_gun(weapon_resources[weapon_choice_index])
	else:
		has_gun = false
		attack()

func _on_reload_timer_timeout():
	can_shoot = true

func instantiate_gun(weapon_resource):
	if has_gun:
		gun_instance = PBGun.new()
		gun_instance.inventory_item = weapon_resource
		add_child(gun_instance)
		gun_instance.global_position = gun_placeholder.global_position
		gun_placeholder.visible = false

func shoot_at_target():
	if has_gun:
		gun_instance.aim(target.global_position)
		# Call the shoot method of the PBGun instance
		if gun_instance.shoot():
			print("Gun fired!")
			can_shoot = false
			$Reload_Timer.start()


func _process(delta):
	if target and is_instance_valid(target) and pebbles_chase:
		if can_shoot:
			shoot_at_target()
			

		
func _get_target_name():
	return "Pebbles"
	
func attack():
	polarSlap.play()
	var damage = 10
	$AnimatedSprite2D.play("slap")
	target.take_damage(damage)
	
func _on_animated_sprite_2d_frame_changed():
	var damage = 10
	if $AnimatedSprite2D.frame == 2 && $AnimatedSprite2D.animation == "slap":
		target.take_damage(damage)
	if $AnimatedSprite2D.frame == 1 && $AnimatedSprite2D.animation == "death":
		$CollisionShape2D.disabled = true

func _on_detection_radius_body_entered(body):
	print("Entered detection radius:", body.name)
	if body.name == _get_target_name():
		target = body
		pebbles_chase = true

func _on_detection_radius_body_exited(body):
	print("Exited detection radius:", body.name)
	if body.name == _get_target_name():
		pebbles_chase = false

func die():
	# This function handles the enemy's death
	if has_gun:
		# Disable the gun's visibility
		gun_instance.visible = false
		# Optionally, remove the gun from the scene
		gun_instance.queue_free()
	# Stop the enemy from shooting or doing any other actions
	set_physics_process(false)
	is_dead = true  # Mark the enemy as dead
	$AnimatedSprite2D.stop()  # Stop any currently playing animation
	$AnimatedSprite2D.play(_get_death_animation_name())
	queue_free()
	
func check_death():
	if health <= 0:
		die()

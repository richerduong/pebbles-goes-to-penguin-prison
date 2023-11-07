extends "res://Entities/Enemies/enemy_base.gd"
@onready var polarSlap = $polarSlap
var machine_gun_sprite: Sprite2D
var gun_instance: PBGun
var machinegun_resource = preload("res://Guns/GunTypes/shotgun.tres")

func _ready():
	instantiate_machine_gun()

func instantiate_machine_gun():
	gun_instance = PBGun.new()
	gun_instance.inventory_item = machinegun_resource # Assuming this sets up the gun properly
	add_child(gun_instance)
	# Position the gun relative to the polar bear
	gun_instance.position = Vector2(20, 0) # Adjust as needed

func shoot_at_target():
	# Make sure the gun is aiming at the target
	gun_instance.aim(target.global_position)
	# Call the shoot method of the PBGun instance
	if gun_instance.shoot():
		print("Gun fired!")

func _process(delta):
	if target and is_instance_valid(target) and pebbles_chase:
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

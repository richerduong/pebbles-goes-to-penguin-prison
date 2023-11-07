extends "res://Entities/Enemies/test_base.gd"
@onready var polarSlap = $polarSlap

const snowball_scene = preload("res://Entities/Enemies/Snowman/snowball.tscn")
@onready var shoot_timer = $ShootTimer
@onready var rotater = $Rotater

const rotate_speed = 100
const shooter_timer_wait_time = 0.2
const spawn_point_count = 4
const radius = 50

func _get_target_name():
	return "Pebbles"
	
func attack():
	# polarSlap.play()
	# var damage = 10
	_shoot()
	print("here")
	$AnimatedSprite2D.play("slap")
	# target.take_damage(damage)
	
func _on_animated_sprite_2d_frame_changed():
	var damage = 10
	if $AnimatedSprite2D.frame == 2 && $AnimatedSprite2D.animation == "slap":
		target.take_damage(damage)
	if $AnimatedSprite2D.frame == 1 && $AnimatedSprite2D.animation == "death":
		$CollisionShape2D.disabled = true

func _shoot():
	var step = 2 * PI / spawn_point_count
	for i in range(spawn_point_count):
		var spawn_point = Node2D.new()
		var pos = Vector2(radius, 0).rotated(step * 1)
		spawn_point.position = pos
		spawn_point.rotation = pos.angle()
		rotater.add_child(spawn_point)
		
	shoot_timer.wait_time = shooter_timer_wait_time
	shoot_timer.start()

func _process(delta: float) -> void:
	var new_rotation = rotater.rotation_degrees + rotate_speed * delta
	rotater.rotation_degrees = fmod(new_rotation, 360)

func _on_shoot_timer_timeout():
	for s in rotater.get_children():
		var bullet = snowball_scene.instantiate()
		get_tree().get_root().add_child(bullet)
		bullet.position = s.global_position
		bullet.rotation = s.global_rotation

# Hit Flash Shader
#@onready var sprite = $AnimatedSprite2D
#@onready var flashTimer = $FlashHitTimer

## Combat
#var pebbles_inattack_zone = false
#var can_take_damage = true
#
#func _ready():
#	$AnimatedSprite2D.connect("animation_finished", Callable(self, "_on_AnimatedSprite2D_animation_finished"))
#	# ... you can add any other initialization logic for this enemy here
#
#func _physics_process(_delta):
#	deal_with_damage()
#	update_health()
#	if pebbles_chase:
#		player = get_node("../Pebbles")
#		position += (pebbles.position - position)/speed
#		$AnimatedSprite2D.play("idle")
#		var direction = (player.position - self.position).normalized()
#		if direction.x < 0:
#			get_node("AnimatedSprite2D").flip_h = true
#		else:
#			get_node("AnimatedSprite2D").flip_h = false
#
#		move_and_collide(Vector2.ZERO)
#
#func take_damage(damage: int) -> void:
#	#take damage 
#	health -= damage
#	#hit flash
#	flash()
#	#if health reaches 0 then delete from scene
#	if health <= 0:
#		$AnimatedSprite2D.play("death")  # Assumes the animation's name is "death"
#		health = 0
#		set_physics_process(false)  # Optional: stops other logic from processing during death animation
#		await $AnimatedSprite2D.animation_finished
#		#queue_free()
#
#func flash():
#	sprite.material.set_shader_parameter("flash_modifier", 0.7)
#	flashTimer.start()
#
#func _on_FlashTimer_timeout():
#	sprite.material.set_shader_parameter("flash_modifier", 0)
#
#func update_health():
#	var healthbar = $HealthBar
#	healthbar.value = health
#
#	if health >= 250:
#		healthbar.visible = false
#	else:
#		healthbar.visible = true
#
#func _on_regen_timer_timeout():
#	if health < 250:
#		health += 20
#		if health > 250:
#			health = 250
#
#	if health <= 0:
#		health = 0
#
#func _on_detection_radius_body_exited(_body):
#	pass
#
#
#func _on_enemy_hitbox_body_entered(body):
#	if body.has_method("pebbles"):
#		pebbles_inattack_zone = true
#
#
#func _on_enemy_hitbox_body_exited(body):
#	if body.has_method("pebbles"):
#		pebbles_inattack_zone = false
#
#func deal_with_damage():
#	if pebbles_inattack_zone and global.pebbles_current_attack == true:
#		if can_take_damage == true:
#			health = health - 20
#			$take_damage_cooldown.start()
#			can_take_damage = false
#			print("pb health = ", health)
#			if health <= 0:
#				self.queue_free()
#
#func attackAnimation():
#	$AnimatedSprite2D.play("attack")
#
#func _on_take_damage_cooldown_timeout():
#	can_take_damage = true
#
#func _on_AnimatedSprite2D_animation_finished():
#	if $AnimatedSprite2D.animation == "death":
#		# Add any logic here that should run after the death animation completes
#		queue_free()
#

extends CharacterBody2D

@export var bullet_scene: PackedScene
var player
var speed = 150
var pebbles_chase = false
var target = null
var health = 250
var can_shoot = false
var inSlapRadius = false
var is_dead = false
var knockback_val = 25

# Flash Hit
@onready var sprite = $AnimatedSprite2D
@onready var flashTimer = $FlashHitTimer

func _get_target_name():
	return "Player"  

func _get_idle_animation_name():
	return "idle" 

func _get_death_animation_name():
	return "death" 

func _get_walk_animation_name():
	return "walk"


# Common logic
func _ready():
	$AnimatedSprite2D.connect("animation_finished", Callable(self, "_on_AnimatedSprite2D_animation_finished"))
#	$AnimatedSprite2D.connect("slap_timer", Callable(self, "_on_slap_timer_timeout"))

func _physics_process(_delta):
	update_health()

	if pebbles_chase:
		player = load("res://Entities/Player/pebbles.tscn").instantiate()
		# Old Speed calculation
		#position += (target.position - position)/speed
		#var direction = (player.position - self.position).normalized()
		
		# New Speed calculation
		var direction = (target.position - position).normalized()
		position += direction * speed * _delta

		if direction.x < 0:
			get_node("AnimatedSprite2D").flip_h = true
		else:
			get_node("AnimatedSprite2D").flip_h = false
		if $AnimatedSprite2D.animation != "slap":
			$AnimatedSprite2D.play(_get_walk_animation_name())

		move_and_collide(Vector2.ZERO)
	else:
		if $AnimatedSprite2D.animation != _get_idle_animation_name():
			$AnimatedSprite2D.play(_get_idle_animation_name())


func _on_detection_radius_body_entered(body):
	if body.name == _get_target_name():
		target = body
		pebbles_chase = true

func take_damage(damage: int, bullet: Bullet ) -> void:
	if is_dead:  # If the enemy is already dead, don't process further damage
		return
	
	health -= damage
	health = max(health, 0) # Ensure health does not go below 0
	update_health() # Update the health bar after changing health value
	flash() # Flash hit
	
	var knockback = bullet.linear_velocity.normalized() * knockback_val
	position += knockback
	
	# Make the enemy chase Pebbles when taking damage
	if target == null or target.name != _get_target_name():
		pebbles_chase = true
		player = load("res://Entities/Player/pebbles.tscn").instantiate()
		target = player
	
	if health <= 0:
		die()

func flash():
	sprite.material.set_shader_parameter("flash_modifier", 0.7)
	flashTimer.start()

func _on_FlashTimer_timeout():
	sprite.material.set_shader_parameter("flash_modifier", 0)

func update_health():
	var healthbar = $HealthBar
	healthbar.value = health
	if health >= 250:
		healthbar.visible = false
	else:
		healthbar.visible = true

func _on_AnimatedSprite2D_animation_finished():
	if $AnimatedSprite2D.animation == "slap":
		if pebbles_chase:
			$AnimatedSprite2D.play(_get_walk_animation_name())
		else:
			$AnimatedSprite2D.play(_get_idle_animation_name())
	elif $AnimatedSprite2D.animation == _get_death_animation_name():
		queue_free()

func _on_slap_radius_body_entered(body):
	if is_dead:
		return

	if body.name == "Pebbles" && health > 0:
			inSlapRadius = true
			target = body
			attack()
			if not can_shoot:
				$slap_timer.start()

			
func _on_slap_radius_body_exited(body):
	if is_dead:
		return
	
	if body.name == "Pebbles":
		inSlapRadius = false
		$slap_timer.stop()
		

func _on_slap_timer_timeout():
	if is_dead:
		return
	
	if inSlapRadius && health > 0:
		attack()
		
func attack():
	$AnimatedSprite2D.play("slap")

func die():
	is_dead = true  # Mark the enemy as dead
	$AnimatedSprite2D.stop()  # Stop any currently playing animation
	$AnimatedSprite2D.play(_get_death_animation_name())
	health = 0
	set_physics_process(false)

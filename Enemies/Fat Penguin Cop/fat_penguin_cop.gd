extends CharacterBody2D

@export var bullet_scene: PackedScene
@onready var lightGunShot = $lightGunShot


var player
var speed = 50
var pebbles_chase = false
var pebbles = null
var health = 250
var can_shoot = true

# Hit Flash Shader
@onready var sprite = $AnimatedSprite2D
@onready var flashTimer = $FlashHitTimer

# Combat
var pebbles_inattack_zone = false
var can_take_damage = true

func _ready():
	$AnimatedSprite2D.connect("animation_finished", Callable(self, "_on_AnimatedSprite2D_animation_finished"))
	
func _physics_process(_delta):
	update_health()
	
	if pebbles_chase:
		player = get_node("../Pebbles")
		shoot_pebbles()
		position += (pebbles.position - position)/speed
		$AnimatedSprite2D.play("running")
		var direction = (player.position - self.position).normalized()
		if direction.x < 0:
			get_node("AnimatedSprite2D").flip_h = true
		else:
			get_node("AnimatedSprite2D").flip_h = false
		
		move_and_collide(Vector2.ZERO)
	else:
		$AnimatedSprite2D.play("idle")
		

func _on_detection_radius_body_entered(body):
	if body.name == "Pebbles":
		pebbles = body
		pebbles_chase = true
		#shoot_pebbles()
		#CALL the shoot function here when he gets detected shoot_pebbles()

func take_damage(damage: int) -> void:
	#take damage 
	health -= damage
	flash()
	
	#if health reaches 0 then delete from scene
	if health <= 0:
		$AnimatedSprite2D.play("death")  # Assumes the animation's name is "death"
		health = 0
		set_physics_process(false)  # Optional: stops other logic from processing during death animation
		await $AnimatedSprite2D.animation_finished
		#queue_free()

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

func _on_regen_timer_timeout():
	if health < 250:
		health += 20
		if health > 250:
			health = 250
	
	if health <= 0:
		health = 0
	
func shoot_pebbles():
	if can_shoot == true:
		var bullet1: Area2D = bullet_scene.instantiate()
		var bullet2: Area2D = bullet_scene.instantiate()
		var bullet3: Area2D = bullet_scene.instantiate()
		
		bullet1.global_position = get_node("Shotgun/Muzzle").global_position
		bullet2.global_position = get_node("Shotgun/Muzzle").global_position
		bullet3.global_position = get_node("Shotgun/Muzzle").global_position
		
		bullet1.look_at(player.global_position)  # Rotate the bullet towards the player's position
		bullet2.look_at(player.global_position)  # Rotate the bullet towards the player's position
		bullet3.look_at(player.global_position)  # Rotate the bullet towards the player's position
		
		bullet1.rotation = get_node("Shotgun").rotation + 0.1
		bullet2.rotation = get_node("Shotgun").rotation
		bullet3.rotation = get_node("Shotgun").rotation + -0.1
		
		owner.add_child(bullet1)
		owner.add_child(bullet2)
		owner.add_child(bullet3)
		lightGunShot.play()
		
		can_shoot = false
		$Reload_Timer.start()

func _on_take_damage_cooldown_timeout():
	can_take_damage = true

func _on_AnimatedSprite2D_animation_finished():
	if $AnimatedSprite2D.animation == "death":
		# Add any logic here that should run after the death animation completes
		queue_free()


func _on_reload_timer_timeout():
	can_shoot = true

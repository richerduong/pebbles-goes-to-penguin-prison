extends CharacterBody2D

@export var gun: InventoryItem = preload("res://Guns/GunTypes/revolver.tres")
@onready var lightGunShot = $lightGunShot

var player
var speed = 200
var pebbles_chase = false
var pebbles = null
var health = 250
var can_shoot = true
var knockback_val = 25

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
		player = load("res://Entities/Player/pebbles.tscn").instantiate()
		#shoot_pebbles()
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

func take_damage(damage: int, bullet: Bullet) -> void:
	#take damage 
	health -= damage
	flash()
	
	var knockback = bullet.linear_velocity.normalized() * knockback_val
	position += knockback
	
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
	
#func shoot_pebbles():
#	if can_shoot == true:
#		gun.shoot()
#		lightGunShot.play()
		
#		can_shoot = false
#		$Reload_Timer.start()

func _on_take_damage_cooldown_timeout():
	can_take_damage = true

func _on_AnimatedSprite2D_animation_finished():
	if $AnimatedSprite2D.animation == "death":
		# Add any logic here that should run after the death animation completes
		queue_free()


func _on_reload_timer_timeout():
	can_shoot = true


func _on_animated_sprite_2d_frame_changed():
	if $AnimatedSprite2D.frame == 1 && $AnimatedSprite2D.animation == "death":
		$CollisionShape2D.disabled = true


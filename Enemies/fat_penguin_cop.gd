extends CharacterBody2D

@export var bullet_scene: PackedScene
@export var player: CharacterBody2D
@export var max_health: int = 20
@export var heal_ammount: int = 1
@onready var health = max_health

var speed = 200
var pebbles_chase = false
var pebbles = null
var can_shoot = true

# Hit Flash Shader
@onready var sprite = $AnimatedSprite2D
@onready var flashTimer = $FlashHitTimer
@onready var shotgun = $Shotgun
@onready var reload_timer = $Reload_Timer

# Combat
var pebbles_inattack_zone = false
var can_take_damage = true

func _ready():
	$AnimatedSprite2D.connect("animation_finished", Callable(self, "_on_AnimatedSprite2D_animation_finished"))
	$HealthBar.max_value = max_health
	
func _physics_process(_delta):
	update_health()
	shotgun.aim_at(player.global_position)
	
	if pebbles_chase:
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
		$AnimatedSprite2D.play("Idle")
		

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
		update_health()
		shotgun.hide()
		$AnimatedSprite2D.play("death")  # Assumes the animation's name is "death"
		health = 0
		set_physics_process(false)  # Optional: stops other logic from processing during death animation
		await $AnimatedSprite2D.animation_finished
		queue_free()

func flash():
	sprite.material.set_shader_parameter("flash_modifier", 0.7)
	flashTimer.start()

func _on_FlashTimer_timeout():
	sprite.material.set_shader_parameter("flash_modifier", 0)

func update_health():
	var healthbar = $HealthBar
	healthbar.value = health
	
	if health >= max_health:
		healthbar.visible = false
	else:
		healthbar.visible = true

func _on_regen_timer_timeout():
	if health < max_health:
		health += heal_ammount
	health = max(0, min(max_health, health))

func _on_detection_radius_body_exited(_body):
	pass
	
func fat_penguin_cop():
	pass
	
	
func shoot_pebbles():
	if reload_timer.is_stopped():
		shotgun.shoot()
		reload_timer.start()

func _on_take_damage_cooldown_timeout():
	can_take_damage = true

func _on_AnimatedSprite2D_animation_finished():
	if $AnimatedSprite2D.animation == "death":
		# Add any logic here that should run after the death animation completes
		queue_free()


func _on_reload_timer_timeout():
	can_shoot = true

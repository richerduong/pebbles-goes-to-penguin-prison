extends CharacterBody2D

@export var max_health: int = 100 # TODO: Change health back to 10
@export var ammo: int = 999
@export var move_speed: float = 250
@export var sprite_2d: Sprite2D
@export var animation_tree: AnimationTree
@export var bullet_scene: PackedScene
@export var damage: int = 1
@onready var health: int = max_health
@onready var gunShot = $gunShot
@onready var gameOver = $GameOverScreen
@onready var sprite2 = $Sprite2D
@onready var flashTimer = $FlashHitTimer

var enemy_inattack_range = false
var enemy_attack_cooldown = true


const LEFT = Vector2(-1, 1)
const RIGHT = Vector2(1 ,1)
const FLOAT_TOL = 0.001


signal health_update
signal pebbles_death
signal pebbles_shoot


func _ready():
	animation_tree.active = true
	#print(self.get_path())

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
	
	if velocity.length() == 0:
		$walking.stop()
	else:
		if $Timer.is_stopped():
			$walking.pitch_scale = randf_range(0.8, 1.2)
			$walking.play()
			$Timer.start(0.2)
	
	
	move_and_slide()
	pick_new_animation_state()
	
	if Input.is_action_just_pressed("shoot"):
		shoot()
  
	if Input.is_action_just_pressed("slap"):
		slap()
	
	#print("Current Animation: ", $AnimationPlayer.current_animation)
	#print("Sprite Frame: ", $Sprite2D.frame)

	
	if Input.is_action_just_pressed("ui_text_backspace"):
		take_damage(1)
	
	

func pick_new_animation_state():
	if abs(velocity.x) < FLOAT_TOL && abs(velocity.y) < FLOAT_TOL:
		animation_tree["parameters/conditions/not_moving"] = true
		animation_tree["parameters/conditions/moving"] = false
	else:
		animation_tree["parameters/conditions/not_moving"] = false
		animation_tree["parameters/conditions/moving"] = true

func shoot():
	if !$ShootCooldown.is_stopped():
		print($ShootCooldown.time_left)
		return
	$ShootCooldown.start()
	if ammo <= 0: return
	ammo -= 1
	pebbles_shoot.emit(ammo)
	
	gunShot.play()
	var bullet1: Area2D = bullet_scene.instantiate()
	var bullet2: Area2D = bullet_scene.instantiate()
	var bullet3: Area2D = bullet_scene.instantiate()

	bullet1.global_position = get_node("Gun/Muzzle").global_position
	bullet2.global_position = get_node("Gun/Muzzle").global_position
	bullet3.global_position = get_node("Gun/Muzzle").global_position
	
	bullet1.rotation = get_node("Gun").rotation + 0.1 
	bullet2.rotation = get_node("Gun").rotation
	bullet3.rotation = get_node("Gun").rotation - 0.1
	
	owner.add_child(bullet1)
	owner.add_child(bullet2)
	owner.add_child(bullet3)
	
func slap():
	$AnimationPlayer.play("slap")

func _on_slap_area_entered(area):
	if area.is_in_group("hurtbox"):
		area.take_damage()

func take_damage(damage: int) -> void:
	#damage is only going to be 1 for pebbles 
	health -= 1
	
	flash()
	#enemy_attack_cooldown = false
	# $attack_cooldown.start()
	if health <= 0:
		health = 0
		sprite2.material.set_shader_parameter("flash_modifier", 0)
		get_tree().paused = true
		sprite_2d.visible = false
		gameOver.visible = true
		print("dead")
		pebbles_death.emit()
	print(health)
	health_update.emit(health, max_health)
	
func flash():
	if sprite2 and sprite2.material:
		sprite2.material.set_shader_parameter("flash_modifier", 0.7)
		flashTimer.start()

func _on_FlashTimer_timeout():
	sprite2.material.set_shader_parameter("flash_modifier", 0)

func pebbles():
	pass

func _on_pebbles_hitbox_body_entered(body):
	if body.has_method("fat_penguin_cop"):
		enemy_inattack_range = true


func _on_pebbles_hitbox_body_exited(body):
	if body.has_method("fat_penguin_cop"):
		enemy_inattack_range = false

func _on_attack_cooldown_timeout():
	enemy_attack_cooldown = true


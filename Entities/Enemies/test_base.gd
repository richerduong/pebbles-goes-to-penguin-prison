extends CharacterBody2D

@export var bullet_scene: PackedScene
var player
var speed = 50
var pebbles_chase = false
var target = null
var health = 250
var can_shoot = false
var inSlapRadius = false


func _get_target_name():
	return "Player"  

func _get_idle_animation_name():
	return "idle" 

func _get_death_animation_name():
	return "death" 

# Common logic
func _ready():
	$AnimatedSprite2D.connect("animation_finished", Callable(self, "_on_AnimatedSprite2D_animation_finished"))
	$AnimatedSprite2D.connect("slap_timer", Callable(self, "_on_slap_timer_timeout"))

func _physics_process(_delta):
	update_health()

	if pebbles_chase:
		player = get_node("../" + _get_target_name())
		position += (target.position - position)/speed
		var direction = (player.position - self.position).normalized()
		if direction.x < 0:
			get_node("AnimatedSprite2D").flip_h = true
		else:
			get_node("AnimatedSprite2D").flip_h = false

		move_and_collide(Vector2.ZERO)
	else:
		$AnimatedSprite2D.play(_get_idle_animation_name())

func _on_detection_radius_body_entered(body):
	if body.name == _get_target_name():
		target = body
		pebbles_chase = true

func take_damage(damage: int) -> void:
	health -= damage
	if health <= 0:
		$AnimatedSprite2D.play(_get_death_animation_name())
		health = 0
		set_physics_process(false)

func update_health():
	var healthbar = $HealthBar
	healthbar.value = health
	if health >= 250:
		healthbar.visible = false
	else:
		healthbar.visible = true

func _on_AnimatedSprite2D_animation_finished():
	if $AnimatedSprite2D.animation == _get_death_animation_name():
		queue_free()
		
func _on_slap_radius_body_entered(body):
	if body.name == "Pebbles":
			inSlapRadius = true
			target = body
			attack()
			if not can_shoot:
				$slap_timer.start()

			
func _on_slap_radius_body_exited(body):
	if body.name == "Pebbles":
		inSlapRadius = false
		$slap_timer.stop()
		

func _on_slap_timer_timeout():
	if inSlapRadius:
		attack()
		
func attack():
	pass

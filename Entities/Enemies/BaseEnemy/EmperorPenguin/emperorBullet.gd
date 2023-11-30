extends Node2D

const speed = 100
const impact_smoke: PackedScene = preload("res://Guns/Bullets/Effects/impact_smoke.tscn")

func _ready():
	add_to_group("bossBullets")
	var player = get_tree().get_nodes_in_group("player")[0]
	if player.animation_tree.get("parameters/conditions/is_sliding"):
		# If yes, ignore the player layer
		# set_collision_mask_value(1, false)
		get_node("Area2D").set_collision_mask_value(1, false)

func _process(delta):
	position += transform.x * speed * delta
	
func _on_kill_timer_timeout():
	queue_free()

func _on_area_2d_body_entered(body):
	if body.name == "Bullet": pass
	# print("Collided with: ", body)
	if body.has_method("take_damage") and body.has_method("handle_player_shoot"):
		var damage = 2
		body.take_damage(damage)
	destroy()

func destroy():
	var smoke = impact_smoke.instantiate()
	smoke.global_position = global_position
	get_node("/root/World/RoomManager/Room").add_child(smoke)
	queue_free()

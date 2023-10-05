extends Area2D

@export var speed = 500
@export var damage: int = 1

@onready var lifetime: Timer = $Lifetime

func _ready():
	lifetime.start()

func _physics_process(delta):
	if lifetime.is_stopped(): queue_free()
	else: position += transform.x * speed * delta

func _on_body_entered(body):
	print("collided with: ", body)
	if body.has_method("take_damage"):
		body.take_damage(damage)
	queue_free()

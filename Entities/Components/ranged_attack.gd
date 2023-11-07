extends Node

@onready var firerate_timer = $Firerate

@export var gun: Gun

var _firerate: float
var _can_fire: bool = true

func _ready():
	firerate_timer.connect("timeout", _set_can_fire)
	if gun.inventory_item:
		set_fire_rate(gun.inventory_item.shooter.firerate)

func set_fire_rate(firerate: float) -> void:
	_firerate = firerate

func shoot() -> bool:
	if _can_fire: 
		_can_fire = false
		firerate_timer.start(_firerate)
		return gun.shoot()
	return false

func get_type():
	return gun.get_type()

func _set_can_fire() -> void:
	_can_fire = true

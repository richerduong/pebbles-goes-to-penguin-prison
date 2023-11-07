extends Node

@onready var player = load("res://Entities/Player/pebbles.tscn").instantiate()
@onready var player_health_bar_ui = $GUI/Panel/HeartsContainer
#@onready var player_ammo_ui = $"GUI/Panel/Ammo Amount"

func _ready():
	init_room()
	
	player.health_update.connect(player_health_bar_ui.set_health)
	#player.pebbles_shoot.connect(player_ammo_ui.set_ammo_amount)
	
	# health bar needs to be initialized here for some reason
	player.emit_signal("health_update", player.max_health, player.max_health)
	#player.emit_signal("pebbles_shoot", player.ammo)

func init_room() -> void:
	RoomManager.setup()
	RoomManager.switch_room(RoomManager.starting_room)
	$intenseMusic.play()

func _physics_process(_delta):
	pass

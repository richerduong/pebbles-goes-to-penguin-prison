extends Node

func _ready():
	init_room()

func init_room() -> void:
	RoomManager.setup()
	RoomManager.switch_room(RoomManager.starting_room)

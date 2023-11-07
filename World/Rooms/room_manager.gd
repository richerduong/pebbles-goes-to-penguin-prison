extends Node

@export var starting_room: String = "res://World/Rooms/RoomPrefabs/starting_room.tscn"
@export var room_list: Array[String] = ["res://World/Rooms/RoomPrefabs/big_room_1.tscn", "res://World/Rooms/RoomPrefabs/small_room_1.tscn"]

static var room_manager_node: Node
static var animation_player: AnimationPlayer
static var pebbles: CharacterBody2D
static var camera: Camera2D
static var _next_room_path: String
var current_room: Node2D

func _ready() -> void:
	get_tree().get_root().connect("size_changed", _window_size_changed)

func setup() -> void:
	room_manager_node = get_node("/root/World/RoomManager")
	animation_player = room_manager_node.get_node("TransitionCanvas/AnimationPlayer")
	pebbles = load("res://Entities/Player/pebbles.tscn").instantiate()
	camera = pebbles.get_node("Camera2D")

func switch_room(room_path: String = "") -> void:
	if room_path == "":
		room_path = room_list.pick_random()
	_next_room_path = room_path
	animation_player.play("fade_in")

func set_camera_bounds(bounds: CollisionShape2D) -> void:
	var bounds_size = bounds.shape.size
	var viewport_size = get_viewport().size * 4 / 5 # why 4/5???
	
	if bounds_size.x * 2 < viewport_size.x: bounds_size.x = viewport_size.x / 2
	if bounds_size.y * 2 < viewport_size.y: bounds_size.y = viewport_size.y / 2
	
	var top = bounds.position.y - bounds_size.y / 2
	var left = bounds.position.x - bounds_size.x / 2
	var bottom = bounds.position.y + bounds_size.y / 2
	var right = bounds.position.x + bounds_size.x / 2
	
	camera.limit_top = top
	camera.limit_left = left
	camera.limit_bottom = bottom
	camera.limit_right = right

func _deferred_switch_room() -> void:
	if current_room != null: current_room.free()
	current_room = load(_next_room_path).instantiate()
	room_manager_node.add_child(current_room)
	pebbles.position = current_room.get_node("PebblesSpawn").position
	if pebbles.get_parent() != room_manager_node:
		room_manager_node.add_child(pebbles)
	set_camera_bounds(current_room.get_node("CameraArea/CameraBounds"))

func _on_animation_player_animation_finished(anim_name) -> void:
	match anim_name:
		"fade_in":
			call_deferred("_deferred_switch_room")
			animation_player.play("fade_out")

func _window_size_changed() -> void:
	if current_room: set_camera_bounds(current_room.get_node("CameraArea/CameraBounds"))

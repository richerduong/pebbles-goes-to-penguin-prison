extends TileMap

@onready var open_door_key: Sprite2D = $OpenDoorKey
@export var next_room: String
const cellv: Vector2i = Vector2i(0,0)
const door_atlas_coords_closed: Vector2i = Vector2i(7,1)
const door_atlas_coords_opened: Vector2i = Vector2i(9,1)
var door_texture_frame: int = 0
var interactable: bool = false

@onready var doorSound = $doorSound

func _physics_process(_delta):
	if interactable and Input.is_action_just_pressed("interact"):
		doorSound.play()
		await get_tree().create_timer(0.15).timeout
		RoomManager.switch_room(next_room)

func _on_interactable_area_area_entered(area):
	if area.name == "PlayerInteractArea":
		open_door_key.visible = true
		interactable = true
		set_cell(0, cellv, 0, door_atlas_coords_opened)

func _on_interactable_area_area_exited(area):
	if area.name == "PlayerInteractArea":
		open_door_key.visible = false
		interactable = false
		set_cell(0, cellv, 0, door_atlas_coords_closed)

extends Control

@onready var pausemenu = $"."
@onready var volumemenu = $Volume
@onready var inputTypeMenu = $InputType

func _process(delta):
	if Input.is_action_pressed("ui_cancel"):
		pausemenu.visible = true
		get_tree().paused = true
		$MarginContainer/VBoxContainer/Resume.grab_focus()

func _on_resume_pressed():
	pausemenu.visible = false
	get_tree().paused = false

func _on_back_to_main_menu_pressed():
	pausemenu.visible = false
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Menu/menu.tscn")

func _on_quit_pressed():
	get_tree().quit()

func _on_volume_pressed():
	$CenterContainer.visible = false
	$MarginContainer.visible = false
	volumemenu.visible = true
	$Volume/MarginContainer/VBoxContainer/master_slider.grab_focus()
	
func _on_input_type_button_pressed():
	$CenterContainer.visible = false
	$MarginContainer.visible = false
	inputTypeMenu.visible = true
	$InputType/VBoxContainer2/InputTypeButton.grab_focus()

func _on_back_pressed():
	volumemenu.visible = false
	inputTypeMenu.visible = false
	$CenterContainer.visible = true
	$MarginContainer.visible = true
	pausemenu.visible = true
	$MarginContainer/VBoxContainer/Resume.grab_focus()

func _on_save_pressed():
	var pebbles_instance = RoomManager.pebbles
	var game_data = get_game_data()
	SaveSystem.save_game(SaveSystem.current_slot, game_data)
	
func get_game_data():
	var pebbles_instance = RoomManager.pebbles
	var fishventory= pebbles_instance.get_node("Fishventory")
	var scene_tree_data = get_scene_tree_data(get_tree().root)
	var data = {
		"player_health": pebbles_instance.get_health(),
		"player_position": pebbles_instance.global_position,
		"fish_count": pebbles_instance.get_fish_count(),
		"fish_items": fishventory.serialize(),
		"current_room": RoomManager.current_room_path,
		"weapons": pebbles_instance.get_inventory_data(),
		"scene_tree": scene_tree_data 
	}
	return data
	
func get_scene_tree_data(root_node: Node) -> Array:
	var nodes_data = []
	_traverse_tree(root_node, nodes_data)
	return nodes_data

func _traverse_tree(node: Node, nodes_data: Array):
	var node_info = {
		"name": node.name,
		"type": node.get_class(),
		"position": _get_node_position(node)
		# Add other properties as needed
	}
	nodes_data.append(node_info)

	# Recursively process children
	for child in node.get_children():
		_traverse_tree(child, nodes_data)

func _get_node_position(node: Node) -> Variant:
	if node is Node2D:  # For 2D nodes
		return node.global_position
	return null  # For nodes that don't have a position property

func _on_input_type_button_item_selected(index):
	if index != -1:
		World.INPUT_SCHEME = index
		EventBus.input_scheme_changed.emit(index)

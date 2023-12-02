# save_system.gd
extends Node
var current_slot = null
signal delete_success
signal delete_error

func save_game(slot, data):
	current_slot = slot
	print("Saved data in " + str(slot) + " and our data is ")
	print(data)
	var save_path = "user://save_slot_" + str(slot) + ".save"
	var save_file = FileAccess.open(save_path, FileAccess.WRITE)  
	if save_file:
		save_file.store_var(data)
		save_file.close()

func load_game(slot):
	current_slot = slot
	var save_path = "user://save_slot_" + str(slot) + ".save"
	if FileAccess.file_exists(save_path):
		print("Loading Game on Slot " + str(slot))
		var save_file = FileAccess.open(save_path, FileAccess.READ)  
		if save_file:
			var data = save_file.get_var()
			save_file.close()
			apply_game_data(data)
	return null

func slot_has_data(slot):
	current_slot = slot
	var save_path = "user://save_slot_" + str(slot) + ".save"
	print("Already had saved data in Slot " + str(slot))
	return FileAccess.file_exists(save_path)

func delete_save(slot):
	var save_path = "user://save_slot_" + str(slot) + ".save"
	var error = DirAccess.remove_absolute(save_path)
	return error


		
func apply_game_data(data):
	var world_scene_path = "res://World/world.tscn"
	if get_tree().current_scene.name != world_scene_path:
		var world_scene = load(world_scene_path) as PackedScene
		var world_instance = world_scene.instantiate()
		get_tree().root.add_child(world_instance)
		get_tree().current_scene = world_instance
	
	if (data["current_room"]):
		RoomManager.switch_room(data["current_room"])
		var player = RoomManager.pebbles
		var fishventory = player.find_child("Fishventory")
		var inventory = player.find_child("Inventory")
		
		if data["fish_items"]:
			data["fish_items"] = fishventory.deserialize(data["fish_items"])
		
		if data["weapons"]:
			data["weapons"] = inventory.set_inventory_data(data["weapons"])
		
		player.saved_fish_count = data["fish_count"]
		player.health = data["player_health"]

func apply_scene_tree_data(scene_tree_data: Array):
	for node_data in scene_tree_data:
		var node = _find_node_by_name_and_type(node_data["name"], node_data["type"])
		print("FOUND NODES IN APPLY_SCENE " , node)
		if node:
			_apply_node_data(node, node_data)
			
func _find_node_by_name_and_type(name: String, type: String) -> Node:
	var nodes = get_tree().get_nodes_in_group("savable") # Assuming you have a group for savable nodes
	for node in nodes:
		if node.name == name and node.get_class() == type:
			return node
	return null
	
func _apply_node_data(node: Node, node_data: Dictionary):
	print("FOUND NODES IN APPLY NODE " , node)
	if node is Node2D and "position" in node_data:
		node.global_position = node_data["position"]

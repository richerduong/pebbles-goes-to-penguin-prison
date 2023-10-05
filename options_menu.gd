extends Control

func _on_back_pressed():
	get_tree().change_scene_to_file("res://menu.tscn")


func _on_volume_pressed():
	get_tree().change_scene_to_file("res://volume_menu.tscn")

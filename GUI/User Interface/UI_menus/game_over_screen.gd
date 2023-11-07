extends CanvasLayer


func _on_play_again_pressed():
	get_tree().paused = false
	#SceneTransition.change_scene("res://Levels/prison_level.tscn", 'dissolve')
	get_tree().change_scene_to_file("res://World/world.tscn")

func _on_quit_pressed():
	get_tree().quit()

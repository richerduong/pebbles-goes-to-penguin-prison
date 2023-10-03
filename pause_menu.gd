extends Control

@onready var main = $"../../"

func _on_resume_pressed():
	main.unpause()

func _on_quit_pressed():
	get_tree().quit()

func _on_volume_pressed():
	main.get_volume_menu()

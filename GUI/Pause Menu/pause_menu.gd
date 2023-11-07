extends Control

@onready var pausemenu = $"."
@onready var volumemenu = $Volume

func _process(_delta):
	pass
	
	if Input.is_action_pressed("ui_cancel"):
		pausemenu.visible = true
		get_tree().paused = true

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

func _on_back_pressed():
	volumemenu.visible = false
	$CenterContainer.visible = true
	$MarginContainer.visible = true
	pausemenu.visible = true

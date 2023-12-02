extends Control

@onready var main_label = $CenterContainer
@onready var main_buttons = $MarginContainer

@onready var option_menu = $Option
@onready var volume_menu = $Volume
@onready var input_type_menu = $InputType
@onready var selectSound = $selectSound
@onready var saveslot = $SaveSlot
@onready var playButton = $MarginContainer/VBoxContainer/Play
@onready var slotButton = $SaveSlot/MarginContainer2/VBoxContainer/SaveSlot1
@onready var volumeButton = $Option/MarginContainer2/VBoxContainer/Volume
@onready var masterVolumeSlider = $Volume/MarginContainer/VBoxContainer/master_slider
@onready var inputTypeButton = $InputType/VBoxContainer2/InputTypeButton
@onready var success_label = get_node("SaveSlot/MarginContainer2/VBoxContainer/Success")
@onready var error_label = get_node("SaveSlot/MarginContainer2/VBoxContainer/Error")

func _ready():
	playButton.grab_focus()

func _on_play_pressed():
	#$TextureRect.visible = true
	selectSound.play()
	
	#SceneTransition.change_scene("res://Levels/prison_level.tscn", 'dissolve')
	main_label.visible = false
	main_buttons.visible = false
	saveslot.visible = true
	slotButton.grab_focus()

func _on_save_slot_1_pressed():
	#$TextureRect.visible = true
	SaveSystem.current_slot = 1
	selectSound.play()
	saveslot.visible = false
	if SaveSystem.slot_has_data(1):
		$ParallaxBackground.visible = false
		$AudioStreamPlayer.playing = false
		SaveSystem.load_game(1)
		
	else:
		SaveSystem.save_game(1, "Slot 1")
		get_tree().change_scene_to_file("res://Intro/intro_cutscene.tscn")

func _on_save_slot_2_pressed():
	SaveSystem.current_slot = 2
	selectSound.play()
	saveslot.visible = false
	if SaveSystem.slot_has_data(2):
		$ParallaxBackground.visible = false
		$AudioStreamPlayer.playing = false
		SaveSystem.load_game(2)
	else:
		SaveSystem.save_game(2, "Slot 2")
		get_tree().change_scene_to_file("res://Intro/intro_cutscene.tscn")

func _on_save_slot_3_pressed():
	SaveSystem.current_slot = 3
	selectSound.play()
	saveslot.visible = false
	if SaveSystem.slot_has_data(3):
		$ParallaxBackground.visible = false
		$AudioStreamPlayer.playing = false
		SaveSystem.load_game(3)
	else:
		SaveSystem.save_game(3, "Slot 3")
		get_tree().change_scene_to_file("res://Intro/intro_cutscene.tscn")

func _on_options_pressed():
	selectSound.play()
	main_label.visible = false
	main_buttons.visible = false
	option_menu.visible = true
	#get_tree().change_scene_to_file("res://options_menu.tscn")
	volumeButton.grab_focus()
	
func _on_exit_pressed():
	selectSound.play()
	get_tree().quit()

func _on_volume_pressed():
	selectSound.play()
	option_menu.visible = false
	volume_menu.visible = true
	masterVolumeSlider.grab_focus()
	
func _on_input_type_pressed():
	selectSound.play()
	option_menu.visible = false
	input_type_menu.visible = true
	inputTypeButton.grab_focus()

func _on_back_pressed():
	selectSound.play()
	main_label.visible = true
	main_buttons.visible = true
	option_menu.visible = false
	volume_menu.visible = false
	input_type_menu.visible = false
	saveslot.visible = false
	playButton.grab_focus()

func _on_input_type_button_item_selected(index):
	if index != -1:
		World.INPUT_SCHEME = index
		EventBus.input_scheme_changed.emit(index)

func _on_trash_1_pressed():
	var error = SaveSystem.delete_save(1)
	if error != OK:
		success_label.visible = false
		error_label.visible = true
	else: 
		success_label.visible = true
		error_label.visible = false

func _on_trash_2_pressed():
	var error = SaveSystem.delete_save(2)
	if error != OK:
		success_label.visible = false
		error_label.visible = true
	else: 
		success_label.visible = true
		error_label.visible = false

func _on_trash_3_pressed():
	var error = SaveSystem.delete_save(3)
	if error != OK:
		success_label.visible = false
		error_label.visible = true
	else: 
		success_label.visible = true
		error_label.visible = false
		


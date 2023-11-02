extends Node2D

# Array of your images/textures
var story_images = [preload("res://Storyboard//sb1.png"), preload("res://Storyboard//sb2.png"), preload("res://Storyboard//sb3.png"), preload("res://Storyboard//sb4.png"), preload("res://Storyboard//sb5.png"), preload("res://Storyboard//sb6.png")]
var current_image = 0

func _ready():
	$Image.texture = story_images[current_image]

# Function to go to the next image
func next_image():
	current_image += 1
	if current_image < story_images.size():
		$Image.texture = story_images[current_image]
	else:
		end_of_story()

# Function to handle end of the story
func end_of_story():
	# Load your main game or any other scene
	get_tree().change_scene_to_file("res://menu.tscn")

func _input(event):
	if event.is_action_pressed("ui_accept"):  # 'ui_accept' is the Enter key by default. You can set to any other key in the Input Map.
		next_image()

func _on_next_pressed():
	next_image()

func _on_skip_pressed():
	end_of_story()

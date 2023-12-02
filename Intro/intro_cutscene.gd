extends Node2D

@onready var skipButton = $Control/skip_button

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play('Intro')
	skipButton.grab_focus()
	await(get_tree().create_timer(40).timeout)
	SceneTransition.change_scene("res://World/world.tscn", 'dissolve')
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_button_pressed():
	get_tree().change_scene_to_file("res://World/world.tscn")

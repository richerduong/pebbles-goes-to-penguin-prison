extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play('Intro')
	await(get_tree().create_timer(40).timeout)
	SceneTransition.change_scene("res://menu.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_button_pressed():
	get_tree().change_scene_to_file("res://menu.tscn")

extends Node2D

func _on_english_pressed():
	Global.in_english = true
	get_tree().change_scene_to_file("res://scenes/story.tscn")

func _on_finnish_pressed():
	get_tree().change_scene_to_file("res://scenes/story.tscn")

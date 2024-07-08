extends Node2D

func _ready():
	if Global.in_english:
		$Label.text = "congratulations! you just got a job and now have to mark the way for a new highway.

unfortunately the highway goes directly through multiple summerhouse locations, and the owners aren't too happy about it..."
		
		$Continue.text = "continue"

func _on_continue_pressed():
	get_tree().change_scene_to_file("res://scenes/level_1.tscn")

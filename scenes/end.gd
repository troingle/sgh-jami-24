extends Node2D

func _ready():
	if Global.in_english:
		$Label.text = "congratulations, you won the game!

the government is grateful."
		$Continue.text = "return to start"

func _on_continue_pressed():
	get_tree().change_scene_to_file("res://scenes/language_select.tscn")

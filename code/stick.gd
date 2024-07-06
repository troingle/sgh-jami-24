extends Node2D

@onready var player = $"../../Player"

func _on_area_2d_body_entered(body):
	if body.is_in_group("marks") and body not in player.marks_already_done:
		player.marks_already_done.append(body)
		player.mark_count += 1

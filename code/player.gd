extends CharacterBody2D

var speed = 220
var accel = 100

var dir

@onready var sprite = $AnimatedSprite2D
@onready var anim = $AnimationPlayer
@onready var place_timer = $PlaceTimer
@onready var camera = $Camera2D
@onready var fade_anim = $CanvasLayer/FadeRect/AnimationPlayer
@onready var start_pos = $"../StartPos"

var stickObj = preload("res://scenes/stick.tscn")
var stick

var num_of_marks = 0 # number of marks in a level
var marks_already_done = [] # list of what individual marks have been marked
var mark_count = 0 # number of successful markings
var stick_count = 0 # number of sticks, successful markings or not

var ended = false
var fight_on = false

var boss_pos = Vector2(9999, 9999)

func _ready():
	fade_anim.play("fade_in")
	Global.paused = false
	
	if Global.in_english:
		if $"..".name == "Level1":
			$"../Labels/Label".text = "use wasd/arrow keys
to move"
			$"../Labels/Label2".text = "place sticks on top of these markings with space"
			$"../Labels/Label3".text = "you lose if your markings are too inaccurate"
			$"../Labels/Label4".text = "don't get caught!"
		elif $"..".name == "Level5":
			$"../Label".text = "watch out for
security cameras!"

		$CanvasLayer/ScoreWindow/Restart.text = "restart level"
		$CanvasLayer/ScoreWindow/Next.text = "continue" 
		
		$CanvasLayer/Sprite2D.position.x += 100


func _physics_process(delta):
	if $"..".name == "Level8":
		boss_pos = $"../FatherInLaw".position
	
	if not fade_anim.is_playing() and position.y > 750:
		position = start_pos.position
		visible = true
		
	dir = Input.get_vector("left", "right", "up", "down")
	velocity.x = move_toward(velocity.x, speed * dir.x, accel)
	velocity.y = move_toward(velocity.y, speed * dir.y, accel)
	if sprite.get_animation() != "place_stick" and not Global.paused:
		if dir.y > 0:
			sprite.play("run_fwd")
			anim.play("wobble")
		elif dir.y < 0:
			sprite.play("run_bwd")
			anim.play("wobble")
		elif dir.x:
			sprite.play("run_side")
			anim.play("wobble")
		else:
			sprite.play("idle")
			anim.play("RESET")
		
		if dir.x > 0 and !dir.y:
			sprite.flip_h = true
		elif dir.x < 0 and !dir.y:
			sprite.flip_h = false
		
	if sprite.get_animation() != "place_stick" and not Global.paused: # reformat this? currently a bit repetitive
		move_and_slide()
	elif sprite.get_animation() != "place_stick":
		anim.pause()
		sprite.pause()
	
	if Input.is_action_pressed("exit"):
		get_tree().quit()
		
	if Input.is_action_pressed("reset"):
		get_tree().reload_current_scene()
		
	if Input.is_action_just_pressed("place") and sprite.get_animation() != "place_stick" and stick_count < num_of_marks and not Global.paused:
		sprite.flip_h = false
		anim.play("RESET")
		sprite.play("place_stick")
		
		stick = stickObj.instantiate()
		$"../Line2D".add_child(stick)
		stick.position = position
		stick.position.x += 17
		
		place_timer.start()
		
	if position.distance_to($"../Car".position) < 56:
		Global.paused = true
		if not ended:
			$CanvasLayer/ScoreWindow.visible = true
			ended = true
		if mark_count >= num_of_marks:
			if not Global.in_english:
				$CanvasLayer/ScoreWindow/Label.text = "onnittelut,
	pääsit läpi!"
			else:
				$CanvasLayer/ScoreWindow/Label.text = "congratulations,
	you passed!"
		else:
			if not Global.in_english:
				$CanvasLayer/ScoreWindow/Label.text = "liian epätarkkoja merkintöjä, et päässyt läpi"
			else:
				$CanvasLayer/ScoreWindow/Label.text = "your markings were too inaccurate, you didn't pass"
			$CanvasLayer/ScoreWindow/Next.modulate = "ffffff5f"
	
	if not Global.in_english:
		$CanvasLayer/LeftLabel.text = str(num_of_marks - stick_count) + " jäljellä"
	else:
		$CanvasLayer/LeftLabel.text = str(num_of_marks - stick_count) + " left"
	
	if boss_pos.distance_to(position) < 37 and not Global.paused:
		death()


func _on_place_timer_timeout():
	sprite.play("idle")
	$"../Line2D".update_line()
	stick.visible = true
	stick_count += 1

func _on_detector_body_entered(body):
	if (body.is_in_group("enemies") and not fight_on):
		death()
		
func fade_and_change(resetting, target_scene):
	await get_tree().create_timer(0.7).timeout
	fade_anim.play("fade_out")
	await get_tree().create_timer(3).timeout
	if resetting:
		Global.paused = false 
		get_tree().reload_current_scene()
	else:
		Global.paused = false
		get_tree().change_scene_to_file(target_scene)

func _on_restart_pressed():
	$CanvasLayer/ScoreWindow.visible = false
	fade_and_change(true, null)

func _on_next_pressed():
	if mark_count >= num_of_marks:
		$CanvasLayer/ScoreWindow.visible = false
		if $"..".name == "Level1":
			fade_and_change(false, "res://scenes/level_2.tscn")
		elif $"..".name == "Level2":
			fade_and_change(false, "res://scenes/level_3.tscn")
		elif $"..".name == "Level3":
			fade_and_change(false, "res://scenes/level_4.tscn")
		elif $"..".name == "Level4":
			fade_and_change(false, "res://scenes/level_5.tscn")
		elif $"..".name == "Level5":
			fade_and_change(false, "res://scenes/level_6.tscn")
		elif $"..".name == "Level6":
			fade_and_change(false, "res://scenes/level_7.tscn")
		elif $"..".name == "Level7":
			fade_and_change(false, "res://scenes/level_8.tscn")
		elif $"..".name == "Level8":
			fade_and_change(false, "res://scenes/end.tscn")
			
func death():
	Global.paused = true
	$Caught.play()
	camera.zoom.x = 1.6
	camera.zoom.y = 1.6
	await get_tree().create_timer(0.4).timeout
	camera.zoom.x = 2
	camera.zoom.y = 2
	await get_tree().create_timer(0.4).timeout
	camera.zoom.x = 3.5
	camera.zoom.y = 3.5
	fade_and_change(true, null)

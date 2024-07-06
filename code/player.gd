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

func _ready():
	fade_anim.play("fade_in")

func _physics_process(delta):
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
		
	if Input.is_action_just_pressed("place") and sprite.get_animation() != "place_stick" and not Global.paused:
		sprite.flip_h = false
		anim.play("RESET")
		sprite.play("place_stick")
		
		stick = stickObj.instantiate()
		$"../Line2D".add_child(stick)
		stick.position = position
		stick.position.x += 17
		
		place_timer.start()
		

func _on_place_timer_timeout():
	sprite.play("idle")
	$"../Line2D".update_line()
	stick.visible = true

func _on_detector_body_entered(body):
	if body.is_in_group("enemies"):
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
		
func fade_and_change(resetting, target_scene):
	await get_tree().create_timer(0.7).timeout
	fade_anim.play("fade_out")
	await get_tree().create_timer(3).timeout
	if resetting:
		Global.paused = false 
		get_tree().reload_current_scene()

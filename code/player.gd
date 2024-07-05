extends CharacterBody2D

var speed = 220
var accel = 100

var dir

@onready var sprite = $AnimatedSprite2D
@onready var anim = $AnimationPlayer
@onready var place_timer = $PlaceTimer

var stickObj = preload("res://scenes/stick.tscn")
var stick

func _physics_process(delta):
	dir = Input.get_vector("left", "right", "up", "down")
	velocity.x = move_toward(velocity.x, speed * dir.x, accel)
	velocity.y = move_toward(velocity.y, speed * dir.y, accel)
	
	if sprite.get_animation() != "place_stick":
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
		
		if dir.x > 0:
			sprite.flip_h = true
		elif dir.x < 0:
			sprite.flip_h = false
		
		move_and_slide()
	
		
	
	if Input.is_action_pressed("exit"):
		get_tree().quit()
		
	if Input.is_action_just_pressed("place"):
		sprite.flip_h = false
		anim.play("RESET")
		sprite.play("place_stick")
		
		stick = stickObj.instantiate()
		$"..".add_child(stick)
		stick.position = position
		stick.position.x += 17
		
		place_timer.start()
		

func _on_place_timer_timeout():
	sprite.play("idle")
	stick.visible = true

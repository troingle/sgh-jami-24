extends CharacterBody2D

var speed = 200.0
var accel = 100.0

var detected

@onready var sprite = $AnimatedSprite2D
@onready var anim = $AnimationPlayer
@onready var nav = $NavigationAgent2D

@onready var player = $"../Player"

func _physics_process(delta):
	if detected and not Global.paused:
		var dir = Vector3()
		
		nav.target_position = player.position
		
		dir = nav.get_next_path_position() - global_position
		dir = dir.normalized()
		
		velocity = velocity.lerp(dir * speed, accel * delta)
		
		move_and_slide()
	elif player.position.y < -1900 and not Global.paused:
		detected = true
		sprite.play("run")
		anim.play("wobble")
		player.fight_on = true
	else:
		sprite.pause()
		anim.pause()
	

extends CharacterBody2D

var detected = true

var start = Vector2.ZERO
var target = Vector2.ZERO

var dir = 1

@onready var player = $"../Player"
@onready var view = $View
@onready var sprite = $AnimatedSprite2D
@onready var anim = $AnimationPlayer

@export var vertical = false
@export var spinner = false
@export var length = 400
@export var speed = 120
@export var spin_dir = 1

var rng = RandomNumberGenerator.new()

func _ready():
	start = position
	if vertical:
		target = Vector2(position.x, position.y + length)
	else:
		target = Vector2(position.x + length, position.y)
	
	sprite.play("walk" + str(rng.randi_range(1, 6)))

func _physics_process(delta):
	if not spinner:
		if vertical:
			velocity.y = speed * dir
			if position.y >= target.y:
				dir = -1
			elif position.y <= start.y:
				dir = 1
			if dir == 1:
				view.rotation = deg_to_rad(90)
			else:
				view.rotation = deg_to_rad(-90)
		else:
			velocity.x = speed * dir
			if position.x >= target.x:
				dir = -1
			elif position.x <= start.x:
				dir = 1
			if dir == 1:
				view.rotation = 0
			else:
				view.rotation = deg_to_rad(-180)
	else:
		view.rotation += 0.024 * spin_dir
		sprite.play("camera")
			
	if not Global.paused:
		move_and_slide()
	else:
		sprite.pause()
		anim.pause()
		
	if player.fight_on:
		$View/Sprite2D.visible = false

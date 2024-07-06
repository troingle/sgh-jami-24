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
@export var length = 400
@export var speed = 120

func _ready():
	start = position
	if vertical:
		target = Vector2(position.x, position.y + length)
	else:
		target = Vector2(position.x + length, position.y)

func _physics_process(delta):
	if vertical:
		velocity.y = speed * dir
		if position.y >= target.y or position.y <= start.y:
			dir *= -1
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
			
	if not Global.paused:
		move_and_slide()
	else:
		sprite.pause()
		anim.pause()

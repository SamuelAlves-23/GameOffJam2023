extends CharacterBody2D


@export var speed = 100.0

@onready var animationPlayer = $AnimationPlayer
@onready var sprite = $Sprite2D

const JUMP_VELOCITY = -400.0

func _physics_process(delta):
	velocity = Vector2(0,0)
	var direction = 0
	
	if Input.is_action_pressed("move_up"):
		velocity.y = -speed
		animationPlayer.play("Move")
	
	if Input.is_action_pressed("move_down"):
		velocity.y = speed
		animationPlayer.play("Move")
	
	if Input.is_action_pressed("move_left"):
		velocity.x = -speed
		direction = -1
		animationPlayer.play("Move")
	
	if Input.is_action_pressed("move_right"):
		velocity.x = speed
		direction = 1
		animationPlayer.play("Move")
	
	if direction != 0:
		sprite.flip_h = (direction == -1)
	
#	if animationPlayer.animation_finished:
#		animationPlayer.stop()
	move_and_slide()

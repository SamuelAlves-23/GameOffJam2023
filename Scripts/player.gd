extends CharacterBody2D
class_name Player

enum {
	MOVE,
	RECOIL
}
var state = MOVE

@export var ACCELERATION = 500
@export var MAX_SPEED = 100
@export var RECOIL_SPEED = 150
@export var FRICTION  = 500

@export var speed = 100.0
@export var recoil_force = 500
@onready var animationPlayer = $AnimationPlayer
@onready var sprite = $Sprite2D
@onready var gun = $Gun
@onready var active = true
@export var size_variation = Vector2(0.5,0.5)

func _process(delta):
	match state:
		MOVE:
			move_state(delta)
		RECOIL:
			pass

func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vector.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		animationPlayer.play("Move")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	move_and_slide()
	
	if Input.is_action_just_pressed("shoot") && gun.scale > Vector2.ONE:
		state = RECOIL

func recoil_state(delta, bullet_scale):
	var current_pos = global_position
	velocity = -(get_global_mouse_position() - current_pos)
	animationPlayer.stop()
	move_and_slide()
#	state = MOVE

func _physics_process(delta):
#	velocity = Vector2(0,0)
	var direction = 0
	if(active):
#		if Input.is_action_pressed("move_up"):
#			velocity.y = -speed
#			animationPlayer.play("Move")
#
#		if Input.is_action_pressed("move_down"):
#			velocity.y = speed
#			animationPlayer.play("Move")
#
#		if Input.is_action_pressed("move_left"):
#			velocity.x = -speed
#			animationPlayer.play("Move")
#
#		if Input.is_action_pressed("move_right"):
#			velocity.x = speed
#			animationPlayer.play("Move")
		
		if Input.is_action_just_pressed("increase_bullet_size"):
			gun.change_gun_size(size_variation)
		if Input.is_action_just_pressed("decrease_bullet_size"):
			gun.change_gun_size(-size_variation)
		
		if Input.is_action_just_pressed("shoot"):
			gun.shoot()
			#recoil(delta, gun.scale)
	
	direction = get_viewport().get_mouse_position().x
	if direction != 0:
		sprite.flip_h = (direction < self.global_position.x)
	
	move_and_slide()

func recoil(delta, scale):
	var direction = 0
	active = false
	active = true
	var current_pos = global_position
	direction = -(get_global_mouse_position() - current_pos)
	translate(direction.normalized() * delta * (recoil_force * scale))

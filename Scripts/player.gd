extends CharacterBody2D


@export var speed = 100.0
@export var recoil_force = 500
@onready var animationPlayer = $AnimationPlayer
@onready var sprite = $Sprite2D
@onready var gun = $Gun
@onready var active = true
@export var size_variation = Vector2(0.5,0.5)

func _physics_process(delta):
	velocity = Vector2(0,0)
	var direction = 0
	if(active):
		if Input.is_action_pressed("move_up"):
			velocity.y = -speed
			animationPlayer.play("Move")
		
		if Input.is_action_pressed("move_down"):
			velocity.y = speed
			animationPlayer.play("Move")
		
		if Input.is_action_pressed("move_left"):
			velocity.x = -speed
			animationPlayer.play("Move")
		
		if Input.is_action_pressed("move_right"):
			velocity.x = speed
			animationPlayer.play("Move")
		
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

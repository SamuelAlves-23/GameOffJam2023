extends CharacterBody2D
class_name Player

enum {
	NONE,
	MAIL
}

enum {
	MOVE,
	RECOIL,
	HIT
}
var state = MOVE
var item_equipped = NONE
var damage_recoil_vector
var recoil_vector = Vector2.DOWN

@export var ACCELERATION = 500
@export var MAX_SPEED = 123
@export var RECOIL_SPEED = 10000
@export var FRICTION  = 500
@export var speed = 100.0
@export var gun_cd = false

@onready var animationPlayer = $AnimationPlayer
@onready var sprite = $Sprite2D
@onready var gun = $Gun
@onready var health_controller = $HealthController
@export var size_variation = Vector2(0.5,0.5)

func _process(delta):
	var direction = get_viewport().get_mouse_position().x
	if direction != 0:
		sprite.flip_h = (direction < self.global_position.x)
	
	match state:
		MOVE:
			move_state(delta)
		RECOIL:
			recoil_state(delta, gun.scale)
		HIT:
			hit_state(delta)

func move_state(delta):
	var direction = get_viewport().get_mouse_position().x
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vector.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
#		animationPlayer.play("Move")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	move_and_slide()
	
	if Input.is_action_just_pressed("increase_bullet_size"):
		gun.change_gun_size(size_variation)
	if Input.is_action_just_pressed("decrease_bullet_size"):
		gun.change_gun_size(-size_variation)
	
	if Input.is_action_pressed("shoot") && !gun_cd:
		gun.shoot()
		if gun.scale > Vector2.ONE:
			state = RECOIL
		gun_cd = true
		await get_tree().create_timer(gun.scale.x - 0.25).timeout
		gun_cd = false

func recoil_state(delta, gun_scale):
	var current_pos = global_position
	recoil_vector = -(get_global_mouse_position() - current_pos)
	recoil_vector = recoil_vector.normalized()
	velocity = RECOIL_SPEED * recoil_vector * delta * gun_scale
	animationPlayer.stop()
	move_and_slide()
	state = MOVE

func hit_state(delta):
	velocity = RECOIL_SPEED * damage_recoil_vector * delta * 3
	move_and_slide()
	state = MOVE

func _on_hurtbox_area_entered(area):
	var current_pos = global_position
	damage_recoil_vector = -(area.global_position - current_pos)
	damage_recoil_vector = damage_recoil_vector.normalized()
	if item_equipped == MAIL:
		print("Funciona")
		item_equipped = NONE
	else:
		health_controller.take_damage(area.damage)
	print(health_controller.health)
	state = HIT

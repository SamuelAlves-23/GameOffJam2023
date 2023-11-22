extends CharacterBody2D
class_name Enemy

enum ENEMY_TYPES{
	MINION,
	SHIELD,
	PARRY,
	GUN
}
enum ENEMY_STATES{
	CHASE,
	DASH,
	SHOOT,
	RECOIL,
	PARALYZED
}

var guarded_sprite
var bulletContainer
var recoil_pos

@onready var damage_color_code = "ff0006"
@onready var recoil_vector = Vector2.DOWN
@onready var state = ENEMY_STATES.CHASE
@onready var health_controller = $HealthController
@onready var sprite = $Sprite2D
@onready var player = get_tree().get_first_node_in_group("Player")
@onready var guarded = true
@onready var guard_life = 20
@onready var dash_speed = 120
@onready var dash_vector = Vector2.DOWN
@onready var gun_cd = false
@onready var invulnerable = false
@onready var bullet_scene = preload("res://Scenes/enemy_bullet.tscn")

@export var enemy_type = ENEMY_TYPES.MINION
@export var ACCELERATION = 300
@export var MAX_SPEED = 20
@export var FRICTION = 200
@export var RECOIL_SPEED = 10000
@export var score_points = 0

func _ready():
	if enemy_type == ENEMY_TYPES.SHIELD:
		guarded_sprite = $GuardedSprite
	elif enemy_type == ENEMY_TYPES.GUN:
		bulletContainer = $BulletContainer

func _physics_process(delta):
	match state:
		ENEMY_STATES.CHASE:
			chase_state(delta)
		ENEMY_STATES.DASH:
			dash_state(delta)
		ENEMY_STATES.SHOOT:
			shoot_state(delta)
		ENEMY_STATES.RECOIL:
			recoil_state(delta)
		ENEMY_STATES.PARALYZED:
			paralyzed_state()

func paralyzed_state():
	await get_tree().create_timer(5).timeout
	state = ENEMY_STATES.CHASE

func chase_state(delta):
	var direction = (player.global_position - global_position).normalized()
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
	sprite.flip_h = velocity.x > 0
	if enemy_type == ENEMY_TYPES.GUN && !gun_cd:
		state = ENEMY_STATES.SHOOT
	move_and_slide()

func recoil_state(delta):
	var current_pos = global_position
	recoil_vector = -(recoil_pos - current_pos)
	recoil_vector = recoil_vector.normalized()
	velocity = RECOIL_SPEED * recoil_vector * delta
	move_and_slide()
	state = ENEMY_STATES.CHASE

func shoot_state(delta):
	var bullet = bullet_scene.instantiate()
	bullet.damage_multiplier = 1
	bulletContainer.add_child(bullet)
	bullet.global_position = global_position
	var current_pos = bullet.global_position
	bullet.direction = (player.global_position - global_position).normalized()
	state = ENEMY_STATES.CHASE
	gun_cd = true
	await get_tree().create_timer(2.5).timeout
	gun_cd = false

func dash_state(delta):
	var direction = (player.global_position - global_position).normalized()
	velocity = velocity.move_toward(direction * dash_speed, ACCELERATION * delta)
	sprite.flip_h = velocity.x > 0
	move_and_slide()
	await get_tree().create_timer(1).timeout
	state = ENEMY_STATES.CHASE
	
func _on_hurtbox_area_entered(area):
	if enemy_type == ENEMY_TYPES.SHIELD && guarded:
		if area.scale.x > 1:
			guard_life -= area.damage
			if guard_life <= 0:
				guarded = false
				guarded_sprite.visible = false
				sprite.visible = true
		else:
			print("Not enough damage")
	elif enemy_type == ENEMY_TYPES.PARRY && area.scale.x >= 1:
		state = ENEMY_STATES.DASH
	else:
		sprite.set_modulate("ff0006")
		health_controller.take_damage(area.damage)
		await get_tree().create_timer(0.1).timeout
		sprite.set_modulate("ffffff")


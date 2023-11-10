extends CharacterBody2D
class_name Enemy

enum ENEMY_TYPES{
	MINION,
	SHIELD,
	PARRY
}
enum ENEMY_STATES{
	CHASE,
	DASH
}

var guarded_sprite

@onready var state = ENEMY_STATES.CHASE
@onready var health_controller = $HealthController
@onready var sprite = $Sprite2D
@onready var player = get_tree().get_first_node_in_group("Player")
@onready var guarded = true
@onready var guard_life = 20
@onready var dash_speed = 120
@onready var dash_vector = Vector2.DOWN

@export var enemy_type = ENEMY_TYPES.MINION
@export var ACCELERATION = 300
@export var MAX_SPEED = 20
@export var FRICTION = 200

func _ready():
	if enemy_type == ENEMY_TYPES.SHIELD:
		guarded_sprite = $GuardedSprite

func _physics_process(delta):
	match state:
		ENEMY_STATES.CHASE:
			chase_state(delta)
		ENEMY_STATES.DASH:
			dash_state(delta)

func chase_state(delta):
	var direction = (player.global_position - global_position).normalized()
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
	sprite.flip_h = velocity.x > 0
	
	move_and_slide()

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
			print(guarded)
		else:
			print("Not enough damage")
	elif enemy_type == ENEMY_TYPES.PARRY && area.scale.x >= 1:
		state = ENEMY_STATES.DASH
		print(state)
	else:
		health_controller.take_damage(area.damage)


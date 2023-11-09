extends CharacterBody2D
class_name Enemy

enum ENEMY_TYPES{
	MINION,
	SHIELD
}

@onready var health_controller = $HealthController
@onready var sprite = $Sprite2D
@onready var player = get_tree().get_first_node_in_group("Player")
@onready var guarded = true

@export var enemy_type = ENEMY_TYPES.MINION
@export var ACCELERATION = 300
@export var MAX_SPEED = 20
@export var FRICTION = 200

func _physics_process(delta):
	var direction = (player.global_position - global_position).normalized()
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
	sprite.flip_h = velocity.x > 0
	
	move_and_slide()


func _on_hurtbox_area_entered(area):
	if enemy_type == ENEMY_TYPES.SHIELD && guarded:
		if area.get_parent().dash_guard:
			guarded = false
			print(guarded)
	else:
		
		health_controller.take_damage(area.damage)


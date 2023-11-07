extends CharacterBody2D
class_name Enemy

@onready var health_controller = $HealthController
@onready var sprite = $Sprite2D
@onready var player = get_tree().get_first_node_in_group("Player")

@export var ACCELERATION = 300
@export var MAX_SPEED = 20
@export var FRICTION = 200


func _physics_process(delta):
	var direction = (player.global_position - global_position).normalized()
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
	sprite.flip_h = velocity.x > 0
	move_and_slide()


func _on_hurtbox_area_entered(area):
	print("Entra")
	health_controller.take_damage(area.damage)


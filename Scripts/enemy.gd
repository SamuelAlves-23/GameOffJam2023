extends CharacterBody2D

@onready var health_controller = $HealthController
@onready var collision_shape = $CollisionShape2D
@onready var sprite = $Sprite2D
@onready var hitbox = $Area2D
@onready var player

@export var ACCELERATION = 300
@export var MAX_SPEED = 20
@export var FRICTION = 200

func _ready():
	player = get_tree().get_first_node_in_group("Player")

func take_damage(damage):
	health_controller.take_damage(damage)

func _physics_process(delta):
	velocity= velocity.move_toward(Vector2.ZERO, FRICTION * delta)

	var direction = (player.global_position - global_position).normalized()
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
	sprite.flip_h = velocity.x > 0

	move_and_slide()

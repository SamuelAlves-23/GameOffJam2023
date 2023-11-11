extends Node2D

@export var speed = 500
@export var min_size = 0.5
@export var max_size = 2
@export var max_spread = 10
var current_spread = 0

@onready var bullet_scene = preload("res://Scenes/bullet.tscn")
@onready var bulletContainer = $BulletContainer
@onready var bullet_pos = $BulletPosition
@onready var player = get_parent()
@onready var bullet = bullet_scene.instantiate()

func _physics_process(delta):
		rotate(get_angle_to(get_viewport().get_mouse_position()))

func shoot():
	var spread_degree_max = current_spread * 0.5
	var spread_radians_actual = deg_to_rad(randf_range(-spread_degree_max, spread_degree_max))
	var spread_increment = max_spread * 0.1
	current_spread = clamp(current_spread + spread_increment, 0, max_spread)
	
	var bullet = bullet_scene.instantiate()
	bulletContainer.add_child(bullet)
	bullet.scale = self.scale
	bullet.global_position = bullet_pos.global_position
	var current_pos = bullet_pos.global_position
	var direction = get_global_mouse_position() - current_pos
	if scale.x < 1:
		bullet.direction = direction.rotated(spread_radians_actual)
	else:
		bullet.direction = get_global_mouse_position() - current_pos
	

func change_gun_size(variation):
	self.scale += variation
	self.scale.x = clamp(self.scale.x, min_size, max_size)
	self.scale.y = clamp(self.scale.y, min_size, max_size)



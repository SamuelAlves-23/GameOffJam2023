extends Node2D

@export var speed = 500
@export var min_size = 0.5
@export var max_size = 2

@onready var bullet_scene = preload("res://Scenes/bullet.tscn")
@onready var bulletContainer = $BulletContainer
@onready var bullet_pos = $BulletPosition
@onready var player
@onready var bullet = bullet_scene.instantiate()

func _ready():
	player = get_parent()

func _physics_process(delta):
	player = get_parent()
	rotate(get_angle_to(get_viewport().get_mouse_position()))
	

func shoot():
	var bullet = bullet_scene.instantiate()
	bulletContainer.add_child(bullet)
	bullet.scale = self.scale - Vector2(0.25, 0.25)
	bullet.global_position = bullet_pos.global_position
	var current_pos = bullet_pos.global_position
	bullet.direction = get_global_mouse_position() - current_pos
	

func change_gun_size(variation):
	self.scale += variation
	self.scale.x = clamp(self.scale.x, min_size, max_size)
	self.scale.y = clamp(self.scale.y, min_size, max_size)



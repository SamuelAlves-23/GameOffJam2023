extends Node2D

@export var speed = 500

@onready var bullet_scene = preload("res://Scenes/bullet.tscn")
@onready var bulletContainer = $BulletContainer

func _ready():
	var bullet = bullet_scene.instantiate()
	bulletContainer.add_child(bullet)
	bullet.global_position = global_position
	pass # Replace with function body.


func _process(delta):
	rotate(get_angle_to(get_viewport().get_mouse_position()))
	
	if Input.is_action_just_pressed("shoot"):
		shoot()

func shoot():
	var bullet = bullet_scene.instantiate()
	bulletContainer.add_child(bullet)
	bullet.global_position = global_position
	var current_pos = global_position
	bullet.direction = get_global_mouse_position() - current_pos

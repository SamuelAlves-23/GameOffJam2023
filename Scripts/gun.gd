extends Node2D

@onready var bullet = preload("res://Scenes/bullet.tscn")

func _ready():
	pass # Replace with function body.


func _process(delta):
	rotate(get_angle_to(get_viewport().get_mouse_position()))
	
	if Input.is_action_just_pressed("shoot"):
		shoot()

func shoot():
	pass

extends Node2D

@export var spawn_time = 1
@export var spawn_active = true

@onready var spawn_cd = false
@onready var spawn_points = []
@onready var mob_container = $MobContainer
@onready var spawn_container = $SpawnContainer
@onready var enemy_01 = preload("res://Scenes/minion_enemy.tscn")


func _ready():
	for i in spawn_container.get_children():
		spawn_points.append(i)
	print(str(spawn_points))


func _process(_delta):
	if !spawn_cd && spawn_active:
		spawn_enemy(enemy_01)
		spawn_cd = true
		await get_tree().create_timer(spawn_time).timeout
		spawn_cd = false
	

func spawn_enemy(enemy):
	var spawn_point = spawn_points.pick_random().global_position
	print(spawn_point)
	var enemy_instance = enemy.instantiate()
	mob_container.add_child(enemy_instance)
	enemy_instance.global_position = spawn_point

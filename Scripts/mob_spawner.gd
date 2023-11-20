extends Node2D

enum SPAWNER_STATES{
	FIRST_PHASE,
	SECOND_PHASE,
	THIRD_PHASE,
	FOURTH_PHASE
}

@export var spawn_time = 1
@export var spawn_active = true

@onready var spawner_state = SPAWNER_STATES.FIRST_PHASE
@onready var spawn_cd = false
@onready var spawn_points = []
@onready var mob_container = $MobContainer
@onready var spawn_container = $SpawnContainer
@onready var enemy_01 = preload("res://Scenes/minion_enemy.tscn")
@onready var gun_enemy = preload("res://Scenes/gun_enemy.tscn")
@onready var shield_enemy = preload("res://Scenes/shield_enemy.tscn")
@onready var parry_enemy = preload("res://Scenes/parry_enemy.tscn")
@onready var final_boss = preload("res://Scenes/final_boss.tscn")

var rng = RandomNumberGenerator.new()
var rng_number
func _ready():
	for i in spawn_container.get_children():
		spawn_points.append(i)


func _process(_delta):
	if !spawn_cd && spawn_active:
		rng_number = rng.randi_range(1,4)
		match spawner_state:
			SPAWNER_STATES.FIRST_PHASE:
				spawn_enemy(enemy_01)
			SPAWNER_STATES.SECOND_PHASE:
				if  rng_number == 1:
					spawn_enemy(shield_enemy)
				else:
					spawn_enemy(enemy_01)
					
			SPAWNER_STATES.THIRD_PHASE:
				if rng_number == 1:
					spawn_enemy(shield_enemy)
				elif rng_number == 2:
					spawn_enemy(parry_enemy)
				else:
					spawn_enemy(enemy_01)
					
			SPAWNER_STATES.FOURTH_PHASE:
				if rng_number == 1:
					spawn_enemy(enemy_01)
				elif rng_number == 2:
					spawn_enemy(shield_enemy)
				elif rng_number == 3:
					spawn_enemy(parry_enemy)
				else:
					spawn_enemy(gun_enemy)
		
		spawn_cd = true
		await get_tree().create_timer(spawn_time).timeout
		spawn_cd = false
	

func spawn_enemy(enemy):
	var spawn_point = spawn_points.pick_random().global_position
	var enemy_instance = enemy.instantiate()
	mob_container.add_child(enemy_instance)
	enemy_instance.global_position = spawn_point

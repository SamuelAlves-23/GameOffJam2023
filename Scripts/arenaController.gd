extends Node2D

@export var level_time = 120

@onready var pickable_01 = preload("res://Scenes/scale_mail.tscn")

@onready var score = 0
@onready var death_screen = $UILayer/DeathScreen
@onready var mob_spawner = $MobSpawner
@onready var player = $Player
@onready var hud = $UILayer/HUD

var pickables = [pickable_01]
var timer_node = null
var level_end = false
var time_left


# Called when the node enters the scene tree for the first time.
func _ready():
	time_left = level_time
	hud.set_time_label(time_left)
	timer_node = Timer.new()
	timer_node.name = "Level Timer"
	timer_node.wait_time = 1
	timer_node.timeout.connect(_on_level_timer_timeout)
	add_child(timer_node)
	timer_node.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player.state == player.PLAYER_STATES.DEATH:
		mob_spawner.spawn_active = false
		death_screen.visible = true
	if score != 0 && score%10 == 0:
		pass

func _on_level_timer_timeout():
	if !level_end:
		time_left -= 1
		hud.set_time_label(time_left)
		if time_left <= 0:
			pass

func add_score():
	score += 1
	print("PUNTUACION: " + str(score))

# REPARAR SPAWN VARIABLE
func spawn_pickable(node_pos):
#	var index = pickables.pick_random()
	var pickable_scene = pickable_01.instantiate()
	self.add_child(pickable_scene)
	pickable_scene = node_pos.global_position

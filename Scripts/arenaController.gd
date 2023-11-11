extends Node2D

@export var level_time = 120

@onready var score = 0
@onready var death_screen = $DeathScreen
@onready var mob_spawner = $MobSpawner
@onready var player = $Player
@onready var hud = $UILayer/HUD

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

func _on_level_timer_timeout():
	if !level_end:
		time_left -= 1
		hud.set_time_label(time_left)
		if time_left <= 0:
			pass

extends Node2D

@export var level_time: float = 180

@onready var score = 0
@onready var death_screen = $UILayer/DeathScreen
@onready var pause_screen = $UILayer/PauseScreen
@onready var mob_spawner = $MobSpawner
@onready var mob_container = $MobSpawner/MobContainer
@onready var player = $Player
@onready var hud = $UILayer/HUD
@onready var pickableContainer = $PickableContainer


var pickables = [
	preload("res://Scenes/scale_mail.tscn"),
	preload("res://Scenes/impulse_wave.tscn"),
	preload("res://Scenes/uncap_bullets.tscn"),
	preload("res://Scenes/sock_death.tscn"),
	preload("res://Scenes/shock.tscn")]
	
var timer_node = null
var level_end = false
var time_left : float
var level_progress : float


func _ready():
	
	time_left = level_time
	hud.set_time_label(time_left)
	timer_node = Timer.new()
	timer_node.name = "Level Timer"
	timer_node.wait_time = 1
	timer_node.timeout.connect(_on_level_timer_timeout)
	add_child(timer_node)
	timer_node.start()


func _process(delta):
	if player.state == player.PLAYER_STATES.DEATH:
		mob_spawner.spawn_active = false
		death_screen.visible = true
	if score != 0 && score%10 == 0:
		pass
	if Input.is_action_just_pressed("Pause"):
		if Engine.time_scale == 1:
			Engine.time_scale = 0
			pause_screen.show()
		else:
			Engine.time_scale = 1
			pause_screen.hide()

func _on_level_timer_timeout():
	if !level_end:
		time_left -= 1
		level_progress = time_left / level_time
		hud.set_time_label(time_left)
		if level_progress < 0.25:
			mob_spawner.spawner_state = mob_spawner.SPAWNER_STATES.FOURTH_PHASE
			print("ESTADO 4")
		elif level_progress < 0.5 && level_progress >= 0.25:
			mob_spawner.spawner_state = mob_spawner.SPAWNER_STATES.THIRD_PHASE
			print("ESTADO 3")
		elif level_progress < 0.75 && level_progress >= 0.5:
			mob_spawner.spawner_state = mob_spawner.SPAWNER_STATES.SECOND_PHASE
			print("ESTADO 2")
		
		if time_left <= 0:
			pass

func add_score():
	score += 1
	print("PUNTUACION: " + str(score))


func spawn_pickable(node_pos):
	var chosen = pickables.pick_random()
	var pickable_scene = chosen.instantiate()
	pickableContainer.add_child(pickable_scene)
	pickable_scene.global_position = node_pos

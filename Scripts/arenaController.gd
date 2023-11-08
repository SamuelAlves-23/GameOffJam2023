extends Node2D

@onready var death_screen = $DeathScreen
@onready var mob_spawner = $MobSpawner
@onready var player = $Player
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player.state == player.PLAYER_STATES.DEATH:
		mob_spawner.spawn_active = false
		death_screen.visible = true

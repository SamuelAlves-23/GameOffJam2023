extends Node

var hurt = preload("res://Assets/Audio/Hurting The Robot.wav")
var player_shot = preload("res://Assets/Audio/alienshoot1.wav")
var enemy_shot = preload("res://Assets/Audio/alienshoot2.wav")
var button = preload("res://Assets/Audio/Randomize2.wav")
var enemy_death = preload("res://Assets/Audio/Laser2.wav")
var player_death = preload("res://Assets/Audio/Randomize4.wav")
var pickup = preload("res://Assets/Audio/Powerup.wav")
var win = preload("res://Assets/Audio/Retro_Game_Sounds_SFX_36.wav")

func play_sfx(sfx_name: String):
	var stream = null
	if sfx_name == "hurt":
		stream = hurt
	elif sfx_name == "player_shot":
		stream = player_shot
	elif sfx_name == "enemy_shot":
		stream = enemy_shot
	elif sfx_name == "button":
		stream = button
	elif sfx_name == "enemy_death":
		stream = enemy_death
	elif sfx_name == "player_death":
		stream = player_death
	elif sfx_name == "pickup":
		stream = pickup
	elif sfx_name == "win":
		stream = win
	
	var asp = AudioStreamPlayer.new()
	asp.stream = stream
	asp.name = "SFX"
	add_child(asp)
	asp.play()

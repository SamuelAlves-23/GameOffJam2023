extends Control



func _on_title_button_pressed():
	AudioPlayer.play_sfx("button")
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
	Engine.time_scale = 1


func _on_retry_button_pressed():
	AudioPlayer.play_sfx("button")
	get_tree().reload_current_scene()
	Engine.time_scale = 1

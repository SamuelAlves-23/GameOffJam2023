extends Control

@onready var arena = get_tree().get_first_node_in_group("Arena")

func _on_resume_button_pressed():
	AudioPlayer.play_sfx("button")
	Engine.time_scale = 1
	self.hide()


func _on_retry_button_pressed():
	AudioPlayer.play_sfx("button")
	get_tree().reload_current_scene()
	Engine.time_scale = 1


func _on_title_button_pressed():
	AudioPlayer.play_sfx("button")
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
	Engine.time_scale = 1
 


func _on_htp_button_pressed():
	self.hide()
	arena.htp_screen.show()

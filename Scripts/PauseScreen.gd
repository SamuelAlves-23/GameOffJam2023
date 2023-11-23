extends Control



func _on_resume_button_pressed():
	Engine.time_scale = 1
	self.hide()


func _on_retry_button_pressed():
	get_tree().reload_current_scene()
	Engine.time_scale = 1


func _on_title_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
	Engine.time_scale = 1

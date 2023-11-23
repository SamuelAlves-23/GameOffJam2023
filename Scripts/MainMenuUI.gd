extends Control

func _on_play_button_button_up():
	get_tree().change_scene_to_file("res://Scenes/test_arena.tscn")


func _on_exit_button_button_up():
	get_tree().quit()

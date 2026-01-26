extends Control

var button_type = null

func _on_play_button_pressed() -> void:
		get_tree().change_scene_to_file("res://scenes/Level_1.tscn")

func _on_controls_button_pressed() -> void:
		get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")


func _on_quit_button_pressed() -> void:
	get_tree().quit()

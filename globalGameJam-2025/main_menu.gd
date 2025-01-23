extends Control

func _on_start_game_pressed() -> void:
	get_tree().change_scene_to_file("res://GameScene.tscn")

func _on_button_2_pressed() -> void:
	get_tree().quit()


func _on_options_button_pressed() -> void:
	get_tree().change_scene_to_file("res://options_menu.tscn")

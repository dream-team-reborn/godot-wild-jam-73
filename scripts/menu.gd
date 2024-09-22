extends Control

func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/game.tscn") # Replace with function body.

func _on_quit_button_pressed() -> void:
	get_tree().quit() # Replace with function body.

func _on_options_button_pressed() -> void:
	$PopupMenu.show()

func _on_exit_pressed() -> void:
	$PopupMenu.hide()

func _on_sound_toggled(toggled_on: bool) -> void:
	var bus_idx = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_mute(bus_idx, toggled_on)

func _on_weird_colors_toggled(toggled_on: bool) -> void:
	GameMan.weird_colors = toggled_on

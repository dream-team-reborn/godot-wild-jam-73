class_name GameManager extends Node

enum GameState { HOME_SCREEN, UI_SELECTION, BLOCK_PLACEMENT }
var game_state: GameState = GameState.BLOCK_PLACEMENT # TODO
var weird_colors: bool = false

func _ready():
	GlobalEventBus.connect("escape", _on_escape)
	pass
	
func _on_escape():
	back_to_menu()
	
func back_to_menu():
	get_tree().change_scene_to_file("res://scenes/menu.tscn") # Replace with function body.

extends Node

signal spawn_module(shape)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("move_right"):
		print("right!")
		
	if event.is_action_pressed("move_left"):
		print("left!")
		
	if event.is_action_pressed("move_up"):
		spawn_module.emit(Module.ModuleShape.CYLINDER)
		print("up!")
		
	if event.is_action_pressed("move_down"):
		spawn_module.emit(Module.ModuleShape.BOX)

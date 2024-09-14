extends Node

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("move_right"):
		print("right!")
		
	if event.is_action_pressed("move_left"):
		print("left!")
		
	if event.is_action_pressed("move_up"):
		%LocalEventBus.publish("shape_selected", [Module.ModuleShape.CYLINDER])
		print("up!")
		
	if event.is_action_pressed("move_down"):
		%LocalEventBus.publish("shape_selected", [Module.ModuleShape.BOX])
		print("down!")
		

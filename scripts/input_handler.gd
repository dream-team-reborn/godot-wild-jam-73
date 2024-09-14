extends Node

func _process(delta: float) -> void:
	var horizontal = Input.get_axis("move_left", "move_right")
	var vertical = Input.get_axis("move_down", "move_up")
	
	GlobalEventBus.publish("move", [Vector2(horizontal, vertical)])

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("confirm"):
		GlobalEventBus.publish("shape_selected", [])

extends Node

func _process(delta: float) -> void:
	var horizontal = Input.get_axis("move_left", "move_right")
	var vertical = Input.get_axis("move_down", "move_up")
	
	match %GameManager.game_state:
		GameManager.GameState.BLOCK_PLACEMENT:
			var move_direction = - Vector2(vertical, horizontal)
			move_direction = move_direction.rotated(%Camera3D.rotation.y)
			GlobalEventBus.publish("move", [move_direction.normalized()])
		GameManager.GameState.UI_SELECTION:
			print("TODO")
		GameManager.GameState.HOME_SCREEN:
			print("TODO")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("confirm"):
		GlobalEventBus.publish("shape_selected", [])
	elif event.is_action_pressed("escape"):
		GlobalEventBus.publish("escape", [])
	elif event.is_action_pressed("spin"):
		GlobalEventBus.publish("spin", [])

extends Node

@export var bus: EventBus


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	bus.connect("player_take_damage", _on_player_take_damage)
	bus.publish("player_take_damage", [100])
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_player_take_damage(value: int) -> void:
	print("Received player_take_damage signal with value: " + str(value))

extends Camera3D

var initial_y: float
var lowest_y: float
var target_y: float
const ANIMATION_TOTAL_TIME = 1
var animation_time = 0

func _ready() -> void:
	initial_y = position.y
	lowest_y = initial_y
	target_y = initial_y
	GlobalEventBus.connect("highest_y", _on_highest_y_change)

func _process(delta: float) -> void:
	_update_y(delta)
	
func _update_y(delta):
	animation_time += delta
	var weight = animation_time/ANIMATION_TOTAL_TIME
	position.y = lerp(lowest_y, target_y, weight)

func _on_highest_y_change(new_y):
	animation_time = 0
	target_y = initial_y + new_y
	lowest_y = position.y

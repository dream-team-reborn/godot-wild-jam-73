extends MeshInstance3D

var angular_velocity: Vector3 = Vector3(0, 4, 0)

var time = 0
var previous_highest = null
var initial_position = null

func _ready():
	global_position.x = 0
	global_position.z = 0
	initial_position = global_position
	GlobalEventBus.connect("highest_change", _on_highest_change)

func _process(delta: float) -> void:
	time += delta
	rotate_object_local(angular_velocity.normalized(), angular_velocity.length() * delta)
	if previous_highest != null:
		global_position.y = up_and_down_animation(previous_highest.global_position.y + 20, time)
	else:
		global_position.y = up_and_down_animation(initial_position.y, time)

func _on_highest_change(highest_block):
	if not previous_highest: 
		previous_highest = highest_block

	if highest_block.global_position.y >= previous_highest.global_position.y:
		previous_highest = highest_block

func up_and_down_animation(starting_y, time):
	return starting_y + (cos(5.5 * time) + 1)

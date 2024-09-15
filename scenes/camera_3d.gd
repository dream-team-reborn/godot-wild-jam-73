extends Camera3D

var initial: Vector3
var lowest: Vector3
var target: Node3D
var old_target_position: Vector3
var lerping_animation: float

func _ready() -> void:
	initial = position
	lowest = initial
	target = null
	GlobalEventBus.connect("highest_change", _on_highest_change)

func _process(delta: float) -> void:
	_update_highest(delta)
	
func _update_highest(delta):
	if not target:
		return

	var target_position = target.global_position
	var look_here
	if lerping_animation < 1:
		look_here = lerp(old_target_position, target_position, lerping_animation)
		lerping_animation += delta
	else:
		look_here = target_position
		old_target_position = look_here
	
	look_here += initial
	position.y = look_here.y
	size = max(45, look_here.y * 1.5)
	var camera_position = global_transform.origin
	var direction_to_target = look_here - initial - camera_position
	var horizontal_distance = Vector2(direction_to_target.x, direction_to_target.z).length()	

func _on_highest_change(highest_block):
	if target != highest_block:
		if not target: 
			target = highest_block
		old_target_position = target.global_position
		target = highest_block
		lerping_animation = 0

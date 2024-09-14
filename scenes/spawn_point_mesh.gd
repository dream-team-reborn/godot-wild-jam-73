extends MeshInstance3D

var angular_velocity: Vector3 = Vector3(0, 4, 0)

var time = 0

func _process(delta: float) -> void:
	time += delta
	rotate_object_local(angular_velocity.normalized(), angular_velocity.length() * delta)
	position.y = (cos(5.5 * (time + delta)) + 1) + 2

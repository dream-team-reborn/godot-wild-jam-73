extends RigidBody3D

func _ready():
	if not GameMan.weird_colors:
		return

	visible = true	
	
func _physics_process(delta: float) -> void:
	angular_velocity = Vector3(1.1, 1, 0)

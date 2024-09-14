class_name Module extends RigidBody3D

enum ModuleShape { CYLINDER, BOX }

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func setup(shape: ModuleShape):
	_setup_shape(shape)
	
func _setup_shape(module_shape: ModuleShape):
	var shape
	var mesh
	
	match module_shape:
		ModuleShape.CYLINDER:
			shape = CylinderShape3D.new()
			shape.radius = 3
			mesh = CylinderMesh.new()
			mesh.top_radius = 3
			mesh.bottom_radius = 3
		ModuleShape.BOX:
			var boxSize = Vector3(4, 2, 4)
			shape = BoxShape3D.new()
			shape.size = boxSize
			mesh = BoxMesh.new()
			mesh.size = boxSize
			
	$CollisionShape3D.shape = shape
	$MeshInstance3D.mesh = mesh

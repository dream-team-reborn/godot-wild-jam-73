class_name Module extends RigidBody3D

enum ModuleShape { CYLINDER, BOX }
enum State { FALLING, PLACED }

const LAYER_MODULE : int = 2
const LAYER_ALL = 0b11111111  # all Modules

var state : State = State.FALLING
var current_mov_dir : Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func setup(shape: ModuleShape):
	GlobalEventBus.connect("move", _on_move)
	
	_setup_shape(shape)
	change_state(State.FALLING)
	set_collision_layer_value(LAYER_MODULE, true)
	
func _physics_process(delta):
	if state == State.FALLING:
		position += Vector3(current_mov_dir.x, -1 * delta, current_mov_dir.y)

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

func _on_body_entered(body: Node) -> void:
	print("collided!")
	change_state(State.PLACED)
	pass

func change_state(new_state: State):
	print("change state to " + State.keys()[new_state])
	state = new_state
	
	freeze = new_state == State.FALLING
	
	match new_state:
		State.FALLING: set_collision_mask(LAYER_MODULE)
		State.PLACED:  set_collision_mask(LAYER_ALL)
		
func _on_move(direction: Vector2):
	current_mov_dir = direction

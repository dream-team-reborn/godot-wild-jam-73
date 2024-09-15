class_name Module extends RigidBody3D

enum ModuleShape { CYLINDER, BOX }
enum State { FALLING, PLACED }

const LAYER_MODULE : int = 2
const LAYER_ALL = 0b11111111  # all Modules

var block: Block
var state : State = State.FALLING
var current_mov_dir : Vector2

const DESTROY_Y = -3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func setup(initial_position: Vector3):
	GlobalEventBus.connect("move", _on_move)
	
	global_position = initial_position
	_setup_shape(block)
	change_state(State.FALLING)
	set_collision_layer_value(LAYER_MODULE, true)
	
func _physics_process(delta):
	if state == State.FALLING:
		position += Vector3(current_mov_dir.x, -1 * delta, current_mov_dir.y)
		GlobalEventBus.publish("module_y", [position.y])
	
	if global_position.y < DESTROY_Y:
		queue_free()

func _setup_shape(block : Block):
	$CollisionShape3D.set_shape(block.mesh.create_convex_shape())
	$MeshInstance3D.mesh = block.mesh
	$ShadowProjector.texture_albedo = block.shadow

func _on_body_entered(body: Node) -> void:
	print("collided!")
	change_state(State.PLACED)
	pass

func change_state(new_state: State):
	print("change state to " + State.keys()[new_state])
	state = new_state
	
	freeze = new_state == State.FALLING
	$ShadowProjector.visible = new_state == State.FALLING
	
	match new_state:
		State.FALLING: set_collision_mask(LAYER_ALL)
		State.PLACED:  set_collision_mask(LAYER_ALL)
		
func _on_move(direction: Vector2):
	current_mov_dir = direction

func release_player_control():
	change_state(State.PLACED)

class_name Module extends RigidBody3D

enum ModuleShape { CYLINDER, BOX }
enum State { MOVING, FALLING, PLACED, DESTROYING }

const LAYER_MODULE : int = 2
const LAYER_ALL = 0b11111111  # all Modules

var block: Block
var state : State = State.MOVING
var current_mov_dir : Vector2

const DESTROY_Y = -3

var particle_scene = preload("res://scenes/particles.tscn")
var rng = RandomNumberGenerator.new()
var other_node: RigidBody3D = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func setup(initial_position: Vector3):
	GlobalEventBus.connect("move", _on_move)
	
	global_position = initial_position
	_setup_shape()
	change_state(State.MOVING)
	set_collision_layer_value(LAYER_MODULE, true)
	
func _physics_process(delta):
	if state == State.MOVING:
		position += Vector3(current_mov_dir.x, -1 * delta, current_mov_dir.y)
		GlobalEventBus.publish("module_y", [position.y])
	
	if global_position.y < DESTROY_Y and state != State.DESTROYING:
		var particle_instance = particle_scene.instantiate() as GPUParticles3D
		particle_instance.global_rotation = Vector3(0, 1, 0)
		add_child(particle_instance)
		change_state(State.DESTROYING)
		var timer = Timer.new()
		timer.autostart = true
		timer.one_shot = true
		timer.wait_time = 10
		timer.timeout.connect(_destroy_module)
		$MeshInstance3D.visible = false
		add_child(timer)
	
	stick_to_other_node(other_node)
	
func _setup_shape():
	$CollisionShape3D.set_shape(block.mesh.create_convex_shape())
	$MeshInstance3D.mesh = block.mesh
	$ShadowProjector.texture_albedo = block.shadow
	var rnd_scale = rng.randf_range(0.9, 1.1)
	scale = Vector3(rnd_scale,rnd_scale,rnd_scale)

func _on_body_entered(body: Node) -> void:
	if state != State.PLACED: change_state(State.PLACED)
	if body as RigidBody3D:
		if (
			other_node == null
			or body.global_position.y < other_node.global_position.y
			or (other_node.global_position - global_position).length() < 3
			):
			other_node = body
	pass

func change_state(new_state: State):
	var previous_state = state
	state = new_state
	gravity_scale = 0 if state == State.MOVING else 3
	$ShadowProjector.visible = new_state == State.MOVING
	
	match new_state:
		State.MOVING: 
			set_collision_mask(LAYER_ALL)
		State.PLACED: 
			set_collision_mask(LAYER_ALL)
			GlobalEventBus.publish("block_placed", [self])
		State.DESTROYING: 
			GlobalEventBus.publish("block_destroyed", [previous_state, self])
		
func _on_move(direction: Vector2):
	current_mov_dir = direction

func release_player_control():
	change_state(State.FALLING)
	linear_velocity = Vector3(0, -10, 0)

func _destroy_module():
	queue_free()

func stick_to_other_node(other_node):
	var force = Vector3(0,0,0)
	if other_node != null:
		var distance = other_node.global_position - global_position
		var dist_len = distance.length()
		if .5 < dist_len and dist_len < 1.5:
			force = distance.normalized()
	global_position += force

class_name Module extends RigidBody3D

enum ModuleShape { CYLINDER, BOX }
enum State { MOVING, FALLING, PLACED, DESTROYING }

const LAYER_MODULE : int = 2
const LAYER_ALL = 0b11111111  # all Modules

var block: Block
var state : State = State.MOVING
var current_mov_dir : Vector2

const DESTROY_Y = -3

var explosion_scene = preload("res://scenes/explosion_particles.tscn")
var raccoon_gain_scene = preload("res://scenes/more_raccoons.tscn")
var rng = RandomNumberGenerator.new()
var other_node: RigidBody3D = null

var is_spinning = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func setup(initial_position: Vector3, _selected_block):
	global_position = initial_position
	block = _selected_block
	_setup_shape()
	change_state(State.MOVING)
	set_collision_layer_value(LAYER_MODULE, true)
	rotation = Vector3(0, rng.randf_range(-PI, PI), 0)
	
	GlobalEventBus.connect("move", _on_move)
	GlobalEventBus.connect("spin", _on_spin)
	
func _physics_process(delta):
	if state == State.MOVING:
		position += Vector3(current_mov_dir.x, -1 * delta, current_mov_dir.y)
		GlobalEventBus.publish("module_y", [position.y])
	
	if global_position.y < DESTROY_Y and state != State.DESTROYING:
		start_particle(explosion_scene.instantiate())
		change_state(State.DESTROYING)
		var timer = Timer.new()
		timer.autostart = true
		timer.one_shot = true
		timer.wait_time = 10
		Music.find_child("Scream").play()
		timer.timeout.connect(_destroy_module)
		$MeshInstance3D.visible = false
		add_child(timer)
	
	stick_to_other_node(other_node)
	if is_spinning:
		spin()
	
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
			if block.population > 0:
				start_particle(raccoon_gain(block.population))
			set_collision_mask(LAYER_ALL)
			GlobalEventBus.publish("block_placed", [self])
			Music.find_child("Pop").play()
		State.DESTROYING: 
			queue_free()
		
func _on_move(direction: Vector2):
	current_mov_dir = direction

func _on_spin():
	is_spinning = not is_spinning

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
		if 1.5 < dist_len:
			other_node = null
		elif .5 < dist_len:
			force = distance.normalized()
			global_rotation += (other_node.global_rotation - global_rotation) / 2
	global_position += force

func spin():
	angular_velocity += Vector3(0, .25, 0)	
	angular_velocity.y = clampf(angular_velocity.y, 0, 20)

func start_particle(particle_instance: GPUParticles3D):
	particle_instance.global_rotation = Vector3(0, 1, 0)
	particle_instance.emitting = true
	add_child(particle_instance)

func raccoon_gain(population):
	var raccoon_gain_instance = raccoon_gain_scene.instantiate() as GPUParticles3D
	raccoon_gain_instance.amount = population
	return raccoon_gain_instance

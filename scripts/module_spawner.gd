extends Node

var module_scene = preload("res://scenes/game_prefabs/module.tscn")

var last_spawned
const POSITION_OFFSET = Vector3(0, -7, 0)

var _selected_block: Block = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalEventBus.connect("shape_selected", _on_spawn_module)
	GlobalEventBus.connect("block_selected", _on_block_selected)
	pass

func _on_block_selected(block: Block) -> void:
	_selected_block = block
	_on_spawn_module()
	
func _on_spawn_module():
	if _selected_block == null:
		return
	
	if last_spawned != null:
		if last_spawned.state == Module.State.MOVING:
			last_spawned.release_player_control()
			return
		last_spawned.release_player_control()
	
	var module_instance = module_scene.instantiate() as Module
	module_instance.block = _selected_block
	module_instance.initial_position = %SpawnerMesh.global_position + POSITION_OFFSET
	add_child(module_instance)
	last_spawned = module_instance

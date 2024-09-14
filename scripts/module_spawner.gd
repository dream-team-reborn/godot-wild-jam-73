extends Node

var module_scene = preload("res://scenes/game_prefabs/module.tscn")

var last_spawned

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalEventBus.connect("shape_selected", _on_spawn_module)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _on_spawn_module():
	print("Spawning module")
	var module_instance = module_scene.instantiate() as Module
	module_instance.block = %BlockFactory.get_random_block()
	add_child(module_instance)
	
	if last_spawned:
		last_spawned.release_player_control()
	last_spawned = module_instance
		
	module_instance.setup()

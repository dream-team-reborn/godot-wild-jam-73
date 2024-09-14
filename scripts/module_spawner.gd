class_name ModuleSpawner extends Node

var module_scene = preload("res://scenes/game_prefabs/module.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	PlayerInputHandler.spawn_module.connect(_on_spawn_module)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _on_spawn_module(shape: Module.ModuleShape):
	print("Spawning module")
	var module_instance = module_scene.instantiate()
	add_child(module_instance)
	module_instance.setup(shape)

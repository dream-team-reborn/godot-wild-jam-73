extends Node3D

@export var blocks: Array[Block]

var rng = RandomNumberGenerator.new()

func get_random_block() -> Block:
	var selected = rng.randi_range(0, len(blocks) - 1)
	return  blocks [selected]

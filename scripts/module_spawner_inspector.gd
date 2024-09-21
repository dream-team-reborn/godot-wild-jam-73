extends Node

const stats: Array[String] = ["cost", "population", "water", "fun"]
const stats_per_sec: Array[String] = ["income_per_sec", "food_per_sec"]

var _stats_value: Dictionary
var _increments_per_sec: Dictionary
var _placed: Array[int]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_setup_timer()
	get_parent().connect("child_exiting_tree", _on_exiting_tree)
	GlobalEventBus.connect("block_placed", _on_block_placed)
	for k in stats_per_sec:
		_increments_per_sec[k] = 0
	for k in stats:
		_stats_value[k] = {"positive": 0, "negative": 0}

func _setup_timer():
	var timer = Timer.new()
	timer.autostart = true
	timer.one_shot = false
	timer.wait_time = .5
	timer.timeout.connect(_on_timer_timeout)
	add_child(timer)

func _on_timer_timeout() -> void:
	var now = Time.get_unix_time_from_system()
	for k in _increments_per_sec:
		var increment = _increments_per_sec[k]
		if increment != 0:
			GlobalEventBus.publish("stat_delta", [k, increment])

	var highest = null
	for child in get_parent().get_children():
		var node = child as Module
		if node:
			if highest == null:
				highest = node
			var block_pos = node.global_position
			var highest_y = highest.global_position.y
			if block_pos != null:
				if highest_y < block_pos.y and node.state == Module.State.PLACED:
					highest = node
	_send_highest_change_signal(highest)

func _on_block_placed(block: Object) -> void:
	var instance_id = block.get_instance_id()
	var module = block as Module
	if module and !_placed.has(instance_id):
		print("Placed from: " + str(instance_id))
		_placed.append(instance_id)
		for k in stats_per_sec:
			var value = module.block.get(k)
			_increments_per_sec[k] += value
			GlobalEventBus.publish("stat_changed", [k, 0, _increments_per_sec[k]])
		for k in _stats_value:
			var value = module.block.get(k)
			if value > 0:
				_stats_value[k]["positive"] += value
			if value < 0:
				_stats_value[k]["negative"] -= value
			var pos = _stats_value[k]["positive"]
			var neg = _stats_value[k]["negative"]
			GlobalEventBus.publish("stat_changed", [k, neg, pos])
		_send_block_number_change_signal()

func _on_exiting_tree(node: Node) -> void:
	var instance_id = node.get_instance_id()
	var module = node as Module
	print("Exit from: " + str(instance_id) + " present in placed: " + str(_placed.has(instance_id)))
	if module and _placed.has(instance_id):
		_placed.erase(instance_id)
		for k in stats_per_sec:
			var value = module.block.get(k)
			_increments_per_sec[k] -= value
			GlobalEventBus.publish("stat_changed", [k, 0, _increments_per_sec[k]])
		for k in _stats_value:
			var value = module.block.get(k)
			if value > 0:
				_stats_value[k]["positive"] -= value
			if value < 0:
				_stats_value[k]["negative"] += value
			var pos = _stats_value[k]["positive"]
			var neg = _stats_value[k]["negative"]
			GlobalEventBus.publish("stat_changed", [k, neg, pos])
		_send_block_number_change_signal()

func _send_block_number_change_signal():
	GlobalEventBus.publish("block_number_change", [0])

func _send_highest_change_signal(highest_block):
	if highest_block != null:
		GlobalEventBus.publish("highest_change", [highest_block])

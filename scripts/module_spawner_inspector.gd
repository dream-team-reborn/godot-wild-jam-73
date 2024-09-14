extends Node

const stats: Array[String] = ["cost", "income", "population", "food", "water", "fun"]

var _blocks: Dictionary 
var _blocks_checks: Dictionary

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_setup_timer()
	get_parent().connect("child_entered_tree", _on_entered_tree)
	get_parent().connect("child_exiting_tree", _on_exiting_tree)
	GlobalEventBus.connect("stat_changed", _on_stat_changed)

func _setup_timer():
	var timer = Timer.new()
	timer.autostart = true
	timer.one_shot = false
	timer.timeout.connect(_on_timer_timeout)
	add_child(timer)

func _on_timer_timeout() -> void:
	var now = Time.get_unix_time_from_system()
	for k in _blocks:
		var block = _blocks[k]
		for stat in stats:
			var last = _blocks_checks[str(k) + "_" + stat]
			var diff = now - last
			if last >= 0 and diff > 0:
				var interval = block.get(stat + "_interval")
				if diff > interval:
					var value = block.get(stat)
					_blocks_checks[str(k) + "_" + stat] = now
					GlobalEventBus.publish("stat_changed", [stat, value])
					if interval == 0:
						_blocks_checks[str(k) + "_" + stat] = -1

func _on_entered_tree(node: Node) -> void:
	var module = node as Module
	if module:
		_blocks[node.get_instance_id()] = module.block
		for stat in stats:
			_blocks_checks[str(node.get_instance_id()) + "_" + stat] = 0
		_send_block_number_change_signal()

func _on_exiting_tree(node: Node) -> void:
	var module = node as Module
	if module:
		_blocks.erase(node.get_instance_id())
		for stat in stats:
			_blocks_checks.erase(str(node.get_instance_id()) + "_" + stat)
		_send_block_number_change_signal()

func _on_stat_changed(stat: String, value: int) -> void:
	print(stat + " changed by " + str(value))

func _send_block_number_change_signal():
	GlobalEventBus.publish("block_number_change", [_blocks.size()])

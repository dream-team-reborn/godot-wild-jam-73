extends Label

var y = 0
var highest_y = 0
var number_of_blocks = 0

func _ready() -> void:
	GlobalEventBus.connect("module_y", _on_update_y)
	GlobalEventBus.connect("block_number_change", _on_block_number_change)
	GlobalEventBus.connect("highest_change", _on_highest_change)

func _on_update_y(other_y):
	y = other_y
	_update_text()

func _on_block_number_change(other_number_of_blocks):
	number_of_blocks = other_number_of_blocks
	_update_text()

func _update_text():
	text = "Block Y: %.02f\nHighest Y: %.02f\nNumber of blocks: %d" % [y, highest_y, number_of_blocks] 

func _on_highest_change(highest_block):
	var highest_pos = highest_block.global_position
	highest_y = highest_pos.y
	_update_text()

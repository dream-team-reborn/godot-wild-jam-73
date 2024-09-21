extends Control

@export var blocks: Array[Block]

var _gui_block = preload("res://scenes/gui_block.tscn")

var _money: int
var _money_increment: int
var _population: int
var _food: int
var _food_increment: int
var _water_neg: int
var _water_pos: int
var _fun_neg: int
var _fun_pos: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalEventBus.connect("stat_delta", _on_stat_delta)
	GlobalEventBus.connect("stat_changed", _on_stat_changed)
	_setup_choose_menu()
	pass

func _setup_choose_menu():
	blocks.sort_custom(func(a: Block, b: Block): return a.cost > b.cost)
	var index = 0
	for block in blocks:
		var child = _gui_block.instantiate()
		if child:
			index += 1
			child.block = block
			child.index = index
			child.pressed.connect(_on_gui_block_pressed)
			%HBoxBlockSelector.add_child(child)
	
func _on_stat_delta(stat: String, delta: int) -> void:
	match stat:
		"income_per_sec":
			_money += delta
		"food_per_sec":
			_food += delta

	_update_ui(stat)

func _on_stat_changed(stat: String, neg: int, pos: int) -> void:
	match stat:
		"income_per_sec":
			_money_increment = pos + neg
		"food_per_sec":
			_food_increment = pos + neg
		"population":
			_population = pos + neg
		"water":
			_water_pos = pos
			_water_neg = neg
		"fun":
			_fun_pos = pos
			_fun_neg = neg
		_:
			pass
	_update_ui(stat)

func _on_gui_block_pressed(block: Block) -> void:
	GlobalEventBus.publish("block_selected", [block])

func _update_ui(stat: String) -> void:
	var text = ""
	match stat:
		"income_per_sec":
			%CostLabel.text = _increment_text_by(_money, _money_increment)
		"food_per_sec":
			%FoodLabel.text = _increment_text_by(_food, _food_increment)
		"population":
			%PopulationLabel.text = "%d" % [_population]
		"water":
			%WaterLabel.text = _consume_text_by(_water_pos - _water_neg, _water_pos)
		"fun":
			%FunLabel.text = _consume_text_by(_fun_pos - _fun_neg, _fun_pos)

func _increment_text_by(total: int, increment: int) -> String:
	var text = "%d %+d/s"
	if total < 0 and increment < 0:
		text = "[color=red]%d %+d/s[/color]"
	elif total < 0:
		text = "[color=red]%d[/color] %+d/s"
	elif increment < 0:
		text = "%d [color=red]%+d/s[/color]"
	return text % [total, increment]

func _consume_text_by(residue: int, total: int) -> String:
	var text = "%d/%d"
	if residue < 0 and total < 0:
		text = "[color=red]%d/%d[/color]"
	elif total < 0:
		text = "%d/[color]%d[/color]"
	elif residue < 0:
		text = "[color=red]%d[/color]/%d"
	return text % [residue, total]

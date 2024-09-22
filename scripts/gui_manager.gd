extends Control

@export var blocks: Array[Block]
@export var timeout: int

var _gui_block = preload("res://scenes/gui_block.tscn")

var _money: int = 250
var _money_increment: int
var _population: int
var _food: int = 150
var _food_increment: int
var _water_neg: int 
var _water_pos: int = 10
var _fun_neg: int
var _fun_pos: int = 10

var _timeout_counting: bool = false
var _timeout_counter: float

func _ready() -> void:
	_timeout_counter = timeout
	GlobalEventBus.connect("stat_delta", _on_stat_delta)
	GlobalEventBus.connect("stat_changed", _on_stat_changed)
	_setup_ui()
	_setup_choose_menu()
	_update_ui("money")
	pass

func _process(delta: float) -> void:
	if %Alert.visible:
		_timeout_counter -= delta
		%TimerLabel.text = "%d" % _timeout_counter
		if _timeout_counter <= 0:
			%Alert.visible = false
			_end_game()

func _setup_ui() -> void:
	%CostLabel.text = _increment_text_by(_money, _money_increment)
	%FoodLabel.text = _increment_text_by(_food, _food_increment)
	%WaterLabel.text = _consume_text_by(_water_pos - _water_neg, _water_pos)
	%FunLabel.text = _consume_text_by(_fun_pos - _fun_neg, _fun_pos)

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
	_check_low_resource()

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

func _check_low_resource() -> void:
	var low = false
	low = low or _money < 0
	low = low or _population < 0
	low = low or _food < 0
	low = low or _water_pos - _water_neg < 0
	low = low or _fun_pos - _fun_neg < 0
	if low and !_timeout_counting:
		_timeout_counting = true
		_timeout_counter = timeout
		%Alert.visible = true
	if !low:
		_timeout_counting = false
		%Alert.visible = false

func _end_game() -> void:
	%GameOver.visible = true
	var timer = Timer.new()
	timer.autostart = true
	timer.one_shot = true
	timer.wait_time = 3
	timer.timeout.connect(_on_end_game_timer_timeout)
	add_child(timer)
	GlobalEventBus.publish("end_game")

func _on_end_game_timer_timeout() -> void:
	GameMan.back_to_menu()

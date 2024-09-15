extends Control

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
	pass

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

func _update_ui(stat: String) -> void:
	match stat:
		"income_per_sec":
			%CostLabel.text = "%d %+d/s" % [_money, _money_increment]
		"food_per_sec":
			%FoodLabel.text = "%d %+d/s" % [_food, _food_increment]
		"population":
			%PopulationLabel.text = "%d" % [_population]
		"water":
			%WaterLabel.text = "%d/%d" % [_water_pos - _water_neg, _water_pos]
		"fun":
			%FunLabel.text = "%d/%d" % [_fun_pos - _fun_neg, _fun_pos]

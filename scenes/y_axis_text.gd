extends Label

func _ready() -> void:
	GlobalEventBus.connect("module_y", _on_update_y)
	
func _on_update_y(y):
	text = "Block Y: %.02f" % y

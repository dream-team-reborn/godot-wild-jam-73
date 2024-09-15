class_name GUIBlock extends VBoxContainer

signal pressed(block)

var block: Block
var index: int

func _ready() -> void:
	%Label.text = str(abs(block.cost))
	%TextureButton.texture_normal = block.preview
	var inputEventKey = InputEventKey.new()
	inputEventKey.keycode = index + 48
	var shortcut = Shortcut.new()
	shortcut.events = [inputEventKey] 
	%TextureButton.shortcut = shortcut 
	%TextureButton.pressed.connect(_on_texture_button_pressed)

func _on_texture_button_pressed() -> void:
	emit_signal(&"pressed", block)

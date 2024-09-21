class_name GUIBlock extends VBoxContainer

signal pressed(block)

var block: Block
var index: int
var block_resource_scene = preload("res://scenes/gui_block_resource.tscn")
var resources = {
	"cost": preload("res://assets/dollar.png"), 
	"population": preload("res://assets/pawns.png"), 
	"water": preload("res://assets/flask_half.png"), 
	"fun": preload("res://assets/suit_hearts.png")
	}

func _ready() -> void:
	%TextureButton.texture_normal = block.preview
	_add_shortcut()
	%TextureButton.pressed.connect(_on_texture_button_pressed)
	for k in resources:
		var child = block_resource_scene.instantiate() as GUIBlockResource
		#print("%s: %s -> %s" % [k, block.get(k), resources[k].load_path])
		child.setup(resources[k], block.get(k))
		%ResourceContainer.add_child(child)

func _on_texture_button_pressed() -> void:
	emit_signal(&"pressed", block)

func _add_shortcut():
	var inputEventKey = InputEventKey.new()
	inputEventKey.keycode = index + 48
	var shortcut = Shortcut.new()
	shortcut.events = [inputEventKey] 
	%TextureButton.shortcut = shortcut 

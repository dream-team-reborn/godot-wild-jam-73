class_name GUIBlock extends Control

signal pressed(block)

var block: Block
var index: int
var block_resource_scene = preload("res://scenes/gui_block_resource.tscn")

var resources = {
	"cost": preload("res://assets/dollar.png"),
	"income_per_sec": preload("res://assets/pouch_add.png"),
	"food_per_sec": preload("res://assets/resource_apple.png"),
	"population": preload("res://assets/pawns.png"), 
	"water": preload("res://assets/flask_half.png"), 
	"fun": preload("res://assets/suit_hearts.png"),
	}

func _ready() -> void:
	%TextureButton.texture_normal = block.preview
	%Name.text = block.name.to_upper()
	_add_shortcut()
	%TextureButton.pressed.connect(_on_texture_button_pressed)
	for k in resources:
		var amount = block.get(k)
		if amount != 0:
			var child = block_resource_scene.instantiate() as GUIBlockResource
			#print("%s: %s -> %s" % [k, amount, resources[k].load_path])
			child.setup(k, resources[k], amount)
			%ResourceContainer.add_child(child)

func _on_texture_button_pressed() -> void:
	emit_signal(&"pressed", block)

func _add_shortcut():
	var inputEventKey = InputEventKey.new()
	inputEventKey.keycode = index + 48
	var shortcut = Shortcut.new()
	shortcut.events = [inputEventKey] 
	%Key.text = "PRESS KEY [%d]" % index
	%TextureButton.shortcut = shortcut 

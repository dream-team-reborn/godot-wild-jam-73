class_name GUIBlock extends VBoxContainer

signal pressed(block)

var block: Block

func _ready() -> void:
	%Label.text = str(abs(block.cost))
	%TextureButton.texture_normal = block.preview
	%TextureButton.pressed.connect(_on_texture_button_pressed)

func _on_texture_button_pressed() -> void:
	emit_signal(&"pressed", block)

class_name GUIBlock extends VBoxContainer

signal block_clicked

var cost: int

func _ready() -> void:
	%Label.text = str(abs(cost))
	%TextureButton.pressed.connect(_on_texture_button_pressed)

func _on_texture_button_pressed() -> void:
	print("Texture button clicked")
	emit_signal(&"block_clicked")

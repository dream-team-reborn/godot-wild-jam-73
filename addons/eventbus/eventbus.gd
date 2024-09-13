@tool
extends EditorPlugin

const CORE_NAME = "EventBus"
const SIGN_NAME = "EventBusSignal"

var icon = preload("res://addons/eventbus/assests/making_plugins-custom_node_icon.webp")
var core = preload("res://addons/eventbus/src/eventbus_core.gd")
var sign = preload("res://addons/eventbus/src/eventbus_signal.gd")

func _enter_tree() -> void:
	# Initialization of the plugin goes here.
	add_custom_type(CORE_NAME, "Node", core, icon)
	add_custom_type(SIGN_NAME, "Node", sign, icon)
	pass


func _exit_tree() -> void:
	# Clean-up of the plugin goes here.
	remove_custom_type(CORE_NAME)
	remove_custom_type(SIGN_NAME)
	pass

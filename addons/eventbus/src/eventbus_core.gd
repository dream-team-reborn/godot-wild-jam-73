@tool
class_name EventBus
extends Node

var _defs: Dictionary = {}

func _enter_tree() -> void:
	connect("child_entered_tree", _child_entered_tree)

func _child_entered_tree(node: Node):
	var sign = node as EventBusSignal
	if sign:
		var params = []
		for param in sign.params:
			params += [{ "name": param.name, "type": param.type }]
			
		add_user_signal(sign.name, params)
		_defs[sign.name] = sign.params
		print("Signal " + sign.name + " added to " + name)

func publish(event: StringName, params: Array[Variant]) -> Error:
	if _check_params_from_def(event, params):
		return callv("emit_signal", [event] + params)
	return ERR_INVALID_PARAMETER
	
	
func _check_params_from_def(event: StringName, params: Array[Variant]) -> bool:
	var def = _defs[event] as Array[EventBusSignal]
	if not def:
		print("Definition not present")
		return false
	var def_len = len(def)
	var params_len = len(params)
	if len(def) != len(params):
		print("Params length are different from definition aspected " + def_len + " received " + params_len)
		return false	
	
	var type_checked = false
	for index in range(0, def_len):
		if is_instance_of(params[index], def[index].type):
			type_checked = true
		else:
			print("Param " + def[index].name + " not of the valid type " + str(def[index].type) + " for event " + event)
			type_checked = false
			break
	
	return type_checked
	

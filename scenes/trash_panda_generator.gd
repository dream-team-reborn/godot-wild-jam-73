extends Node

var _raccoon_scene = preload("res://scenes/raccoon.tscn")

func _ready() -> void:
	var raccoon_amount = 40
	var circles = 100
	for c in range(circles):
		for i in range(raccoon_amount):
			var raccoon = _raccoon_scene.instantiate() as Node3D
			await get_tree().create_timer(0.001).timeout
			add_child(raccoon)
			raccoon.global_position.x = cos(2 * PI * i/raccoon_amount + (c/5.))
			raccoon.global_position.z = sin(2 * PI * i/raccoon_amount + (c/5.))
			raccoon.global_position *= 20 * sqrt(2) + (c * c + c)
			raccoon.global_position.y = 1
			raccoon.look_at_from_position(raccoon.global_position, Vector3(0,0,0))
			raccoon.rotate(Vector3(0,1,0), PI/2)

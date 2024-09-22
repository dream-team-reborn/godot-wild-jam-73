class_name GUIBlockResource
extends BoxContainer

func setup(resource: String, texture: CompressedTexture2D, amount: int):
	match resource:
		"income_per_sec":
			%Label.text = "%d/s" % amount
		"food_per_sec":
			%Label.text = "%d/s" % amount
		_:
			%Label.text = "%d" % amount
	%Texture.texture = texture

class_name GUIBlockResource
extends BoxContainer

func setup(texture: CompressedTexture2D, amount):
	%Label.text = str(amount)
	print(texture.load_path)
	%Texture.texture = texture

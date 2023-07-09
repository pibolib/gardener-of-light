extends Interactable
class_name TileInteractive

func _ready():
	texture = AtlasTexture.new()
	texture.set("atlas", load("res://asset/world/interactables.png"))
	texture.set("region", Rect2(0,0,16,16))
	$Sprite.rotation = 0


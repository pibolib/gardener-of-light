extends StaticBody2D
class_name Tile

@onready var sprite = $Sprite2D
var sprite_atlas_position: Vector2i

func _ready():
	sprite.region_rect.position = Vector2(sprite_atlas_position)
	if sprite.region_rect.position == Vector2(16, 0):
		$LightOccluder2D.visible = false
		$LightOccluder2D2.visible = true
		sprite.region_rect.position =Vector2(randi_range(0, 1)*16, 48)
	else:
		sprite.region_rect.position =Vector2(randi_range(0, 1)*16, 32)

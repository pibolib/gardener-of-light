extends StaticBody2D

@onready var sprite = $Sprite2D
var sprite_atlas_position: Vector2i

func _ready():
	sprite.region_rect.position = Vector2(sprite_atlas_position)
	if sprite.region_rect.position == Vector2(16, 0):
		$LightOccluder2D.visible = false
		$LightOccluder2D2.visible = true

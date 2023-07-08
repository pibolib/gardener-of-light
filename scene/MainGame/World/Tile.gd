extends StaticBody2D

@onready var sprite = $Sprite2D
var sprite_atlas_position: Vector2i

func _ready():
	sprite.region_rect.position = Vector2(sprite_atlas_position)

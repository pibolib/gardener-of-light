extends Area2D
class_name Powerup

@onready var collision_shape_2d = $CollisionShape2D
@export var game_handler: Node

func _ready():
	game_handler = get_parent()
	game_handler.connect("mode_switch", _on_mode_switch)

func _on_mode_switch(mode: GameHandler.Mode) -> void:
	if mode == GameHandler.Mode.DAY:
		set_enable(true)
	else:
		set_enable(false)

func set_enable(state: bool) -> void:
	if state:
		$Sprite.region_rect.position = Vector2(16,0)
	else:
		$Sprite.region_rect.position = Vector2(0,0)
	collision_shape_2d.set_deferred("disabled", !state)

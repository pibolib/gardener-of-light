extends Area2D
class_name TaintBlob

var z: float = -0.01
var zsp: float = -70
var g: float = 90
var do_3d_anim: bool = true
var velocity := Vector2.ZERO

var grow: bool = false
@export var game_handler: Node


func _ready():
	velocity = Vector2.from_angle(randf_range(0, TAU)) * randf_range(0, 20)
	game_handler = get_parent()
	game_handler.connect("mode_switch", _on_mode_switch)

func _process(delta):
	if clamp(position.x, 0, 320) != position.x:
		queue_free()
	elif clamp(position.y, 0, 240) != position.y:
		queue_free()
	if do_3d_anim:
		if z < 0:
			z += zsp * delta
			zsp += g * delta
			position += velocity * delta
		else:
			do_3d_anim = false
			g = 0
			z = 0
			$CollisionShape2D.disabled = false
			game_handler.taint_count += 1
	else:
		if $Sprite.scale.x < 1 and grow:
			$Sprite.scale += Vector2(delta/16, delta/16)
		else:
			grow = false
	z_index = -z - 8
	$CollisionShape2D.scale = $Sprite.scale
	$Sprite.position.y = z
	if $Sprite.scale.x <= 0:
		game_handler.taint_count -= 1
		queue_free()

func _on_mode_switch(mode: GameHandler.Mode):
	grow = mode == GameHandler.Mode.NIGHT

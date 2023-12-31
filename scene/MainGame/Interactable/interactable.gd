extends Area2D
class_name Interactable

@export var speed: float = 300
var rotation_timer: Timer
var texture: Texture2D = preload("res://asset/world/funnyarrow.png")

func _ready():
	texture = AtlasTexture.new()
	texture.set("atlas", load("res://asset/world/interactables.png"))
	texture.set("region", Rect2(16,0,16,16))
	connect("body_entered", _on_area_2d_body_entered)
	rotation_timer = Timer.new()
	add_child(rotation_timer)
	rotation_timer.start(2)
	rotation_timer.connect("timeout", _rotate)

func _on_area_2d_body_entered(body):
	if body is CharacterBody2D:
		body.position = position
		body.move_enable = false
		body.velocity = Vector2.from_angle(rotation).normalized() * speed 
		$AudioStreamPlayer2D.pitch_scale = randf_range(0.95,1.05)
		$AudioStreamPlayer2D.play()
		var timer := get_tree().create_timer(0.25)
		await timer.timeout
		body.move_enable = true

func _rotate():
	#rotation += PI/2
	pass

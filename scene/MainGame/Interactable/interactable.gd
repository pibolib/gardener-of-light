extends Area2D
class_name Interactable

@export var speed: float = 300
var rotation_timer: Timer

func _ready():
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
		var timer := get_tree().create_timer(0.25)
		await timer.timeout
		body.move_enable = true

func _rotate():
	#rotation += PI/2
	pass

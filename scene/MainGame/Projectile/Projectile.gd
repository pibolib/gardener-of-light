extends Area2D

var velocity := Vector2.ZERO
var speed: float = 200
var attack_angle: float = 0

func _ready():
	velocity = Vector2.from_angle(attack_angle) * speed

func _process(delta):
	position += velocity * delta

func _on_area_entered(area):
	queue_free()

func _on_body_entered(body):
	queue_free()

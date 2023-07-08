extends Interactable

func _on_area_2d_body_entered(body):
	if body is Enemy:
		body.damage(3)
		queue_free()

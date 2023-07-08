extends Interactable
class_name Flower

func _ready():
	pass # Replace with function body.

func _process(delta):
	for area in $Clear.get_overlapping_areas():
		if area is TaintBlob:
			area.get_node("Sprite").scale -= Vector2(delta/4, delta/4)

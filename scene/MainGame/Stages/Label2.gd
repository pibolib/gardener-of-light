extends Label

func _process(_delta):
	if get_parent().get_parent().flower == 2:
		queue_free()

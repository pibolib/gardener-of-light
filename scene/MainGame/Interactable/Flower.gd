extends Interactable
class_name Flower

var max_power: float = 10
var remaining_power: float = 5
var cooldown: bool = false
var refresh_timer: Timer

func _ready():
	texture = AtlasTexture.new()
	texture.set("atlas", load("res://asset/powerup/flower-Sheet.png"))
	texture.set("region", Rect2(32,0,16,16))
	refresh_timer = Timer.new()
	refresh_timer.connect("timeout", refresh)
	add_child(refresh_timer)
	cooldown_start(5)

func _process(delta):
	if !cooldown:
		var found: bool = false
		for area in $Clear.get_overlapping_areas():
			if area is TaintBlob:
				area.get_node("Sprite").scale -= Vector2(delta/4, delta/4)
				remaining_power -= delta
				found = true
		if !found:
			remaining_power += delta
		$Absorb.emitting = found
		if remaining_power <= 0:
			cooldown_start()
			cooldown = true
	else:
		$Absorb.emitting = false
	$Shine.visible = !cooldown
	$Shine.rotation += delta/12
	$Sprite.region_rect.position = Vector2(clamp(int(3*remaining_power/max_power)*16, 0, 48), 0)

func cooldown_start(time: float = 5) -> void:
	cooldown = true
	refresh_timer.start(time)

func refresh() -> void:
	cooldown = false
	remaining_power = max_power
	refresh_timer.stop()

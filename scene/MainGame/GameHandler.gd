extends Node2D
class_name GameHandler

enum Mode {
	DAY,
	NIGHT
}

@export var cycle_time: float = 10
var mode := Mode.DAY
var mode_timer: Timer
@onready var ui = $UI
@onready var label = $UI/Label

var player_position = Vector2.ZERO

signal mode_switch(mode)

func _ready():
	mode_timer = Timer.new()
	add_child(mode_timer)
	mode_timer.start(cycle_time)
	mode_timer.connect("timeout", _on_mode_timer_timeout)

func _process(_delta):
	label.text = "Mode: %d, Time Remaining: %d" % [mode, mode_timer.time_left]

func _on_mode_timer_timeout() -> void:
	if mode == Mode.DAY:
		mode = Mode.NIGHT
	else:
		mode = Mode.DAY
	mode_switch.emit(mode)

extends Node2D
class_name GameHandler

enum Mode {
	DAY,
	NIGHT
}

const TILE := preload("res://scene/MainGame/World/Tile.tscn")

@export var cycle_time: float = 10
var mode := Mode.DAY
var mode_timer: Timer
@onready var ui = $UI
@onready var label = $UI/Label
@onready var tile_map = $TileMap

var player_position = Vector2.ZERO

signal mode_switch(mode)

func _ready():
	randomize()
	for tile in tile_map.get_used_cells(1):
		var new_tile = TILE.instantiate()
		new_tile.position = tile_map.map_to_local(tile)
		new_tile.sprite_atlas_position = tile_map.get_cell_atlas_coords(1, tile) * 16
		tile_map.set_cell(1, tile, -1)
		add_child(new_tile)
	
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

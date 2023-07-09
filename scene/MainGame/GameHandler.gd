extends Node2D
class_name GameHandler

enum Mode {
	DAY,
	NIGHT
}

const BGM := preload("res://asset/bgm/bgm.ogg")

const TILE := preload("res://scene/MainGame/World/Tile.tscn")
const TILE_INTERACTIVE := preload("res://scene/MainGame/Interactable/TileInteractive.tscn")
const TAINT := preload("res://scene/MainGame/Taint/Taint.tscn")

@export var cycle_time: float = 10
var mode := Mode.NIGHT
var mode_timer: Timer
@onready var ui = $UI
@onready var label = $UI/Label
@onready var tile_map = $TileMap

var player_position = Vector2.ZERO
var taint_count: int = 0

signal mode_switch(mode)

func _ready():
	Global.play_bgm(BGM)
	randomize()
	for i in 25:
		var taint := TAINT.instantiate()
		taint.position = Vector2(randf_range(16, 304), randf_range(16, 224))
		add_child(taint)
	mode_switch.emit(Mode.NIGHT)
	for tile in tile_map.get_used_cells(1):
		if tile_map.get_cell_atlas_coords(1, tile) == Vector2i(3, 0):
			var new_tile = TILE_INTERACTIVE.instantiate()
			new_tile.position = tile_map.map_to_local(tile)
			tile_map.set_cell(1, tile, -1)
			add_child(new_tile)
		else:
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
	label.text = "Mode: %d, Time Remaining: %d\nTaint Count: %d/100" % [mode, mode_timer.time_left, taint_count]

func _on_mode_timer_timeout() -> void:
	var tween := get_tree().create_tween()
	if mode == Mode.DAY:
		mode = Mode.NIGHT
		tween.tween_property($CanvasModulate, "color", Color(0, 0, 0, 1), 1)
	else:
		mode = Mode.DAY
		tween.tween_property($CanvasModulate, "color", Color(1, 1, 1, 1), 1)
	mode_switch.emit(mode)

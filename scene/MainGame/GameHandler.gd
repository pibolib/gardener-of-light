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
@export var next_stage: String
var mode := Mode.NIGHT
var mode_timer: Timer
@onready var ui = $UI
@onready var label = $UI/Label
@onready var tile_map = $TileMap

@export var taint_initial: int = 25
var player_position = Vector2.ZERO
var taint_count: int = 0
var check: float = 0
var levelcomplete: bool = false
var stage_failed: bool = false
@export var title_screen: bool = false
var flower: int = 0

signal mode_switch(mode)

func _ready():
	$Loop1.playing = true
	$Loop2.playing = true
	$UI.visible = !title_screen
	if !title_screen:
		$CanvasModulate.visible = true
	Global.play_bgm(BGM)
	randomize()
	for i in taint_initial:
		var taint := TAINT.instantiate()
		taint.position = Vector2(randf_range($Markers/TL.position.x+16, $Markers/BR.position.x-16), randf_range($Markers/TL.position.y+16, $Markers/BR.position.y-16))
		taint.auto = true
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

func _process(delta: float):
	if taint_count >= 75:
		$Loop1.volume_db = lerp($Loop1.volume_db, 0.0, delta)
	else:
		$Loop1.volume_db = lerp($Loop1.volume_db, -80.0, delta)
	if taint_count >= 90:
		$Loop2.volume_db = lerp($Loop2.volume_db, 0.0, delta)
	else:
		$Loop2.volume_db = lerp($Loop2.volume_db, -80.0, delta)
	$UI/TimeTop/TimeBottom.rotation = (1-mode)*PI + mode_timer.time_left/cycle_time * PI
	$UI/NinePatchRect.set_size(Vector2(194*(float(taint_count)/100), 9))
	label.text = "Taint: %d%%" % [taint_count]
	if taint_count == 0 and !stage_failed:
		check += delta
		if check >= 1 and !levelcomplete:
			levelcomplete = true
			mode_timer.stop()
			if mode != Mode.DAY:
				mode_switch.emit(Mode.DAY)
			$UI/Next.visible = true
	else:
		check = 0
	if taint_count >= 100 and !stage_failed:
		$UI/Retry.visible = true
		stage_failed = true

func _on_mode_timer_timeout() -> void:
	var tween := get_tree().create_tween()
	if mode == Mode.DAY:
		mode = Mode.NIGHT
		tween.tween_property($CanvasModulate, "color", Color(0, 0, 0, 1), 1)
	else:
		mode = Mode.DAY
		tween.tween_property($CanvasModulate, "color", Color(1, 1, 1, 1), 1)
	mode_switch.emit(mode)

func _on_retry_pressed():
	Global.get_node("Retry").play()
	get_tree().reload_current_scene()

func _on_next_pressed():
	Global.get_node("Next").play()
	get_tree().change_scene_to_file(next_stage)

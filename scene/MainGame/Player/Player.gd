extends CharacterBody2D
class_name Player

enum Ability {
	NONE,
	BASIC
}

const INTERACTABLE := preload("res://scene/MainGame/Interactable/interactable.tscn")

@export var max_speed: float = 65
@export var speed: float = 65
var movement_angle: float = 0
var attack_angle: float = 0
var ability := Ability.NONE
var friction: float = 0.01
var move_enable = true
var attack_timer: Timer
var attack_ready: bool = true
var slow: bool = false

var pick_up: Interactable
var holding: String = ""

@export var game_handler: Node
@onready var aim_marker_pivot = $AimMarkerPivot

const PROJECTILE_BASIC := preload("res://scene/MainGame/Projectile/Projectile.tscn")

func _ready():
	attack_timer = Timer.new()
	attack_timer.connect("timeout", attack_refresh)
	add_child(attack_timer)
	$Sprite.play("default")
	if !game_handler == null:
		game_handler.connect("mode_switch", _on_mode_switch)

func _process(delta):
	game_handler.player_position = global_position
	aim_marker_pivot.rotation = lerp_angle(aim_marker_pivot.rotation, attack_angle, delta*20)
	if velocity.length() > 0.1:
		$Sprite.animation = "run"
	else:
		$Sprite.animation = "default"
	$Spacebar.global_position = $AimMarkerPivot/AimIndicator.global_position + Vector2(0, 8)
	if Input.is_action_just_pressed("action"):
		if holding != "":
			var new_interactable = load(holding).instantiate()
			new_interactable.global_position = Vector2(16*game_handler.get_node("TileMap").local_to_map($AimMarkerPivot/AimIndicator.global_position)) + Vector2(8,8)
			new_interactable.rotation = attack_angle
			add_sibling(new_interactable)
			holding = ""
		if pick_up != null:
			holding = pick_up.scene_file_path
			pick_up.queue_free()
			move_enable = true
			pick_up = null

func _physics_process(delta):
	slow = false
	for area in $Main.get_overlapping_areas():
		if area is TaintBlob:
			slow = true
			break
	if slow:
		speed = max_speed/2
	else:
		speed = max_speed
	if move_enable:
		var is_moving = false
		if Input.is_action_pressed("move_up"):
			movement_angle = 3*TAU/4
			attack_angle = 3*TAU/4
			is_moving = true
		elif Input.is_action_pressed("move_down"):
			movement_angle = TAU/4
			attack_angle = TAU/4
			is_moving = true
		if Input.is_action_pressed("move_left"):
			if is_moving:
				movement_angle = lerp_angle(movement_angle, TAU/2, 0.5)
			else:
				movement_angle = TAU/2
			attack_angle = TAU/2
			is_moving = true
			$Sprite.scale.x = -1
		elif Input.is_action_pressed("move_right"):
			if is_moving:
				movement_angle = lerp_angle(movement_angle, 0, 0.5)
			else:
				movement_angle = 0
			attack_angle = 0
			is_moving = true
			$Sprite.scale.x = 1 
		if is_moving:
			velocity = Vector2.from_angle(movement_angle) * speed
		else:
			velocity = Vector2.ZERO
	move_and_slide()
#
#	if ability != Ability.NONE and Input.is_action_just_pressed("action") and attack_ready and game_handler.mode == GameHandler.Mode.DAY:
#		var proj := PROJECTILE_BASIC.instantiate()
#		proj.position = position
#		proj.attack_angle = attack_angle
#		add_sibling(proj)
#		attack_ready = false
#		attack_timer.start(0.5)

func _on_mode_switch(mode: GameHandler.Mode) -> void:
	pass

func _on_item_pickup_area_entered(area) -> void:
	if area is Interactable:
		$Spacebar.visible = true
		pick_up = area

func _on_item_pickup_area_exited(area):
	if area is Interactable:
		$Spacebar.visible = false
		pick_up = null

func attack_refresh() -> void:
	attack_timer.stop()
	attack_ready = true

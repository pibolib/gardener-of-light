extends CharacterBody2D

enum Ability {
	NONE,
	BASIC
}

@export var speed: float = 65
var movement_angle: float = 0
var attack_angle: float = 0
var ability := Ability.NONE

@export var game_handler: Node
@onready var aim_marker_pivot = $AimMarkerPivot

const PROJECTILE_BASIC := preload("res://scene/MainGame/Projectile/Projectile.tscn")

func _ready():
	if !game_handler == null:
		game_handler.connect("mode_switch", _on_mode_switch)

func _process(delta):
	game_handler.player_position = position
	aim_marker_pivot.rotation = lerp_angle(aim_marker_pivot.rotation, attack_angle, delta*20)

func _physics_process(delta):
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
	elif Input.is_action_pressed("move_right"):
		if is_moving:
			movement_angle = lerp_angle(movement_angle, 0, 0.5)
		else:
			movement_angle = 0
		attack_angle = 0
		is_moving = true
	if ability != Ability.NONE and Input.is_action_just_pressed("action"):
		var proj := PROJECTILE_BASIC.instantiate()
		proj.position = position
		proj.attack_angle = attack_angle
		add_sibling(proj)
	velocity = int(is_moving) * Vector2.from_angle(movement_angle) * speed
	move_and_slide()

func _on_mode_switch(mode: GameHandler.Mode) -> void:
	pass

func _on_item_pickup_area_entered(area) -> void:
	if area is Powerup:
		area.set_enable(false)
		ability = Ability.BASIC
		print("picked up item")

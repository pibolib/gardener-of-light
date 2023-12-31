extends CharacterBody2D
class_name Enemy

const TAINT = preload("res://scene/MainGame/Taint/Taint.tscn")
var grunts := [preload("res://asset/sfx/Enemy_Idle_1.wav"), preload("res://asset/sfx/Enemy_Idle_2.wav"), preload("res://asset/sfx/Enemy_Idle_3.wav")]

var speed: float = 25
@export var target := Vector2(100, 100)
var move_enable: bool = false
@export var follow_player: bool = true
@export var hp: int = 3

@onready var navigation_agent = $NavigationAgent2D
@export var spawning: bool = false
var game_handler: GameHandler
# Called when the node enters the scene tree for the first time.
func _ready():
	$AudioPlayer2.stream = grunts.pick_random()
	game_handler = get_parent()
	game_handler.connect("mode_switch", _on_mode_switch)
	if spawning:
		$Sprite.play("spawn")
	else:
		$Sprite.play("default")
		call_deferred("nav_target")

func nav_target() -> void:
	await get_tree().physics_frame
	navigation_agent.target_position = get_node("../Player").global_position

func _process(delta):
	if velocity.x != 0:
		$Sprite.scale.x = -sign(velocity.x)

func _physics_process(delta):
	if follow_player:
		nav_target()
	elif navigation_agent.is_navigation_finished():
		nav_target()
		return
	var next_path_position: Vector2 = navigation_agent.get_next_path_position()
	if move_enable:
		var new_vel: Vector2 = next_path_position - global_position
		new_vel = new_vel.normalized() * speed
		navigation_agent.set_velocity(new_vel)

func _on_navigation_agent_2d_velocity_computed(safe_velocity):
	if move_enable:
		velocity = safe_velocity * int(move_enable)
	if game_handler.mode != GameHandler.Mode.DAY:
		move_and_slide()

func _on_mode_switch(mode: GameHandler.Mode):
	if !spawning:
		if mode == GameHandler.Mode.DAY:
			for i in 3:
				var taint := TAINT.instantiate()
				taint.position = position
				add_sibling(taint)
			$Sprite.animation = "default"
			$AnimationPlayer.play("Idle")
		else:
			$AudioPlayer2.play()
			$AnimationPlayer.play("Walk")
			$Sprite.animation = "run"
		move_enable = !(mode == GameHandler.Mode.DAY)

func damage(amount: int) -> void:
	hp -= amount
	if hp <= 0:
		queue_free()

func _on_sprite_animation_finished():
	if $Sprite.animation == "spawn":
		spawning = false
		$Sprite.play("default")
		_on_mode_switch(game_handler.mode)
		call_deferred("nav_target")

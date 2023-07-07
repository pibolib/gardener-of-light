extends CharacterBody2D

var speed: float = 40
@export var target := Vector2(100, 100)

@onready var navigation_agent = $NavigationAgent2D
var game_handler: GameHandler

# Called when the node enters the scene tree for the first time.
func _ready():
	game_handler = get_parent()
	call_deferred("nav_target")

func nav_target() -> void:
	await get_tree().physics_frame
	navigation_agent.target_position = game_handler.player_position

func _physics_process(delta):
	if navigation_agent.is_navigation_finished():
		call_deferred("nav_target")
		return
	var next_path_position: Vector2 = navigation_agent.get_next_path_position()
	
	var new_vel: Vector2 = next_path_position - global_position
	new_vel = new_vel.normalized() * speed
	
	velocity = new_vel
	move_and_slide()

extends CharacterBody2D
class_name Player

@onready var StateMachine = $StateMachine
@onready var Sprite = $Body/AnimatedSprite2D
@onready var Body = $Body
@onready var crossTimer = $CrossTimer
@onready var orientationTimer = $OrientationTimer

@onready var floor_ray = $Body/FloorRay

signal tile_collided(collision_info: KinematicCollision2D)
signal tile_exited()

const GRAVITY = 275.00
const STRONG_GRAVITY = 400.00
const SPEED = 80.0
const AERIAL_SPEED = 80.0
const ACCELLERATION = 10
@export var JUMP_FORCE: float = 10.0
const WALL_JUMP_FORCE = 80.0
const JAB_TIME = 0.25
const CROSS_TIME = 0.25
const POWER_CROSS_TIME = 0.5
const CROSS_READY_TIME = 0.15

var current_direction : int
var new_direction: float:
	set(value):
		current_direction = sign(value)
		Body.scale.x = current_direction

var current_orientation: int
var new_orientation: float:
	set(value):
		current_orientation = sign(value)
		Body.scale.x = current_orientation

var cross_ready : bool:
	set(value):
		cross_ready = value
		if value == false:
			crossTimer.stop()
			return # To prevent recursion when cross_ready gets disabled
		if crossTimer.time_left == 0:
			crossTimer.start()

var orientation_ready : bool:
	set(value):
		orientation_ready = value
		

func _ready():
	StateMachine._set_state("idle")
	StateMachine.change_animation.connect(_on_change_animation)
	crossTimer.wait_time = CROSS_READY_TIME

func set_state(state : String):
	StateMachine._set_state(state)
	
	
func _physics_process(delta):
	move_and_slide()
	var collision = get_last_slide_collision()
	
	if floor_ray.is_colliding():
		var point = floor_ray.get_collision_point()
		var normal = floor_ray.get_collision_normal()
		var collider = floor_ray.get_collider()
		tile_collided.emit(point, normal, collider)
	else:
		tile_exited.emit()
	
	

func _on_change_animation(new_animation):
	Sprite.set_animation(new_animation)
	Sprite.play()

func _on_cross_timer_timeout():
	cross_ready = false
	

func _on_orientation_timer_timeout():
	orientation_ready = true


func _on_crouch_jab_body_entered(body):
	pass # Replace with function body.

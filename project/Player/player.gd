extends CharacterBody2D
class_name Player

const DEBUG_STATE = "idle"

@onready var StateMachine = $StateMachine
@onready var Sprite = $Body/AnimatedSprite2D
@onready var Body = $Body
@onready var crossTimer = $CrossTimer
@onready var orientationTimer = $OrientationTimer
@onready var softCollision = $SoftCollision

@onready var floor_ray = $Body/FloorRay

signal tile_collided(collision_info: KinematicCollision2D)
signal new_tile_entered(collision_tile, map_layer)
signal tile_exited()
signal player_died()

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
@export var FRICTION: int = 10

var current_tile: Vector2i

var max_health = 3
var health

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
	StateMachine._set_state(DEBUG_STATE)
	StateMachine.change_animation.connect(_on_change_animation)
	$HurtBox.take_hit.connect(_on_hurtbox_take_hit)
	
	health = max_health

func set_state(state : String):
	StateMachine._set_state(state)
	

func _physics_process(delta):
	check_colliding(delta)
	move_and_slide()
	var collision = get_last_slide_collision()
	
	if floor_ray.is_colliding():
		var point = floor_ray.get_collision_point()
		var normal = floor_ray.get_collision_normal()
		var collider = floor_ray.get_collider()
		
		if collider is TileMapLayer:
			var no_states = ['idle', 'jab', 'cross', 'hook']
			var current_state = $StateMachine.current_state.to_string()
			if current_state in no_states:
				pass
			var collision_tile = collider.local_to_map(collider.to_local(point))
			if collision_tile != current_tile:
				new_tile_entered.emit(collision_tile, collider)
			current_tile = collision_tile
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
	
func check_colliding(delta):
	if softCollision.has_overlapping_areas():
		#if current_state == "idle" || current_state == "chase":
		velocity.x += softCollision.get_push_vector().x * delta * 150
		
func _on_hurtbox_take_hit(force, damage):
	$StateMachine._set_state('hurt')
	velocity += force
	health -= damage
	print(health)
	
	if health == 0:
		player_died.emit()

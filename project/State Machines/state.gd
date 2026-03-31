extends Node
class_name State

signal change_animation(new_animation)
signal change_state(new_state)

var actor : Node
var player : Node

func _enter_state():
	pass
	
func _exit_state():
	pass

func _update(delta):
	pass

func _physics_update(delta):
	pass

func apply_gravity(actor, delta):
	if actor.is_on_floor():
		return
	else:
		actor.velocity.y += actor.GRAVITY * delta
		
func apply_friction(actor, delta):
	actor.velocity.x = move_toward(actor.velocity.x, 0, actor.FRICTION * delta)

func process_jump():
	change_state.emit("jump")

func check_jumping():
	if Input.is_action_just_pressed("ui_jump"):
		process_jump()

func process_punch():
	change_state.emit("jab") # Can be overwritten in each state
	
func check_punching():
	if Input.is_action_just_pressed("ui_punch"):
		process_punch()

func set_actor(new_actor):
	actor = new_actor

func set_player(new_player):
	player = new_player

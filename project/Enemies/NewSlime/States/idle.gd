extends State

@export var playerDetection : Node

func _enter_state():
	change_animation.emit("idle")
	print(actor)
	actor.velocity = Vector2.ZERO
	

func _physics_update(delta):
	apply_gravity(actor, delta)
	check_falling()
	apply_friction(actor, delta)
	

func check_falling():
	if ! actor.is_on_floor():
		change_state.emit('fall')

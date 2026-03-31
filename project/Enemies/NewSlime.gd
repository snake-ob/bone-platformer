extends Enemy

const SPEED = 20.0
const ACCELLERATION = 100.0
const JUMP_HEIGHT = 130.0
const JUMP_LENGTH = 50.0
const GRAVITY = 275.0
const FRICTION = 50.0
const MAX_HEALTH = 10

func _on_hurt_box_take_hit(force, damage):
	StateMachine._set_state("recover")
	velocity += force

func _ready():
	# Run the parent's setup first
	super()
	
	StateMachine._set_state("idle")

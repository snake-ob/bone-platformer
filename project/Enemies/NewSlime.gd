extends Enemy

const SPEED = 20.0
const ACCELLERATION = 100.0
const JUMP_HEIGHT = 130.0
const JUMP_LENGTH = 50.0
const GRAVITY = 275.0
const FRICTION = 50.0
const MAX_HEALTH = 10
const PREF_SLOT = 2
var health : int

var target_pos : Vector2
var target_slot = 1

signal get_target_position(requester)

func _on_hurt_box_take_hit(force, damage):
	velocity += force
	
func _ready():
	# Run the parent's setup first
	super()
	StateMachine._set_state("idle")
	health = MAX_HEALTH
	
func _on_hurt_box_take_stun(force: Variant, damage: Variant) -> void:
	StateMachine._set_state("stun")

func _on_hurt_box_take_slam(force:Variant, damage: Variant) -> void:
	velocity += force * 2
	if $StateMachine.current_state.name == "Stun":
		StateMachine._set_state("death")
		
func _set_target_position(new_pos):
	target_pos = new_pos
	
func _set_state(new_state):
	$StateMachine._set_state(new_state)

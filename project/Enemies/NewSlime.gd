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
var target_slot = 2

signal get_target_position(requester)
signal player_range(enemy)
signal player_lost(enemy)

func _on_hurt_box_take_hit(force, damage):
	velocity += force
	
func _ready():
	# Run the parent's setup first
	super()
	StateMachine._set_state("idle")
	health = MAX_HEALTH
	$DetectionZone.player_detected.connect(_player_detected)
	$DetectionZone.player_lost.connect(_player_lost)
	
func _player_detected():
	in_player_range = true
	player_range.emit(self)
	

func _player_lost():
	in_player_range = false
	player_lost.emit(self)
	
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

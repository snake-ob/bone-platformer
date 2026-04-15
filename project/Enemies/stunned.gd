extends State

# Stunned, can either be splatted by player, or back to idle

@export var playerDetection : Node
var direction
var stun_timer : Timer

func _ready():
	stun_timer = Timer.new()
	add_child(stun_timer)
	stun_timer.one_shot = true
	stun_timer.timeout.connect(_stun_timeout)


func _enter_state():
	change_animation.emit("stun")
	actor.velocity = Vector2.ZERO
	stun_timer.start(3.0)

func _exit_state():
	stun_timer.stop()

func _physics_update(delta):
	apply_gravity(actor, delta)
	apply_friction(actor, delta)


func _stun_timeout():
	change_state.emit('idle')

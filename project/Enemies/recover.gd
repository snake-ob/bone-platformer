extends State

@export var playerDetection : Node
var direction
var stun_timer : Timer

func _ready():
	stun_timer = Timer.new()
	add_child(stun_timer)
	stun_timer.one_shot = true
	stun_timer.timeout.connect(_stun_timeout)

func _enter_state():
	change_animation.emit("recover")
	actor.velocity = Vector2.ZERO
	stun_timer.start(1.0)

func _exit_state():
	stun_timer.stop()

func _physics_update(delta):
	apply_gravity(actor, delta)
	check_falling()
	apply_friction(actor, delta)
	

func check_falling():
	if ! actor.is_on_floor():
		change_state.emit('fall')

func _stun_timeout():
	change_state.emit('idle')

extends State

# Wander in left or right direction for x time (1-4 seconds)

@export var playerDetection : Node
var direction
var wander_timer : Timer

func _ready():
	wander_timer = Timer.new()
	add_child(wander_timer)
	wander_timer.one_shot = true
	wander_timer.timeout.connect(_wander_timeout)
	
func _exit_state():
	wander_timer.stop()

func _enter_state():
	change_animation.emit("walk")
	actor.velocity = Vector2.ZERO
	var time_to_wander = randi_range(1,4)
	wander_timer.start(time_to_wander)
	direction = (randi() % 2) * 2 - 1 #reutrns -1 or 1

func _physics_update(delta):
	actor.new_direction = direction
	actor.velocity.x = move_toward(actor.velocity.x, direction * actor.SPEED, actor.ACCELLERATION * delta)
	apply_gravity(actor, delta)
	check_falling()
	apply_friction(actor, delta)
	

func check_falling():
	if ! actor.is_on_floor():
		change_state.emit('fall')

func _wander_timeout():
	change_state.emit('idle')

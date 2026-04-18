extends State

var idle_timer : Timer
var slot_timer : Timer

signal disable_hitbox()

func _ready():
	idle_timer = Timer.new()
	add_child(idle_timer)
	idle_timer.one_shot = true
	idle_timer.timeout.connect(_idle_timeout)
	
	slot_timer = Timer.new()
	add_child(slot_timer)
	slot_timer.timeout.connect(_slot_timeout)

func _enter_state():
	change_animation.emit("idle")
	actor.velocity = Vector2.ZERO
	var time_to_idle = randi_range(3,7)
	idle_timer.start(time_to_idle)
	slot_timer.start(0.5)
	
	disable_hitbox.emit()
	
	
func _exit_state():
	idle_timer.stop()
	slot_timer.stop()

func _physics_update(delta):
	apply_gravity(actor, delta)
	check_falling()
	apply_friction(actor, delta)

func check_falling():
	if ! actor.is_on_floor():
		change_state.emit('fall')

func _idle_timeout():
	if actor.in_player_range:
		change_state.emit('slotting')
	else:
		change_state.emit('wander')
		
func _slot_timeout():
	if actor.in_player_range:
		change_state.emit('slotting')

extends Node
class_name StateMachine

var states = {}

var previous_state : State
var current_state : State

signal state_changed(new_state)

func _ready():
	for state in get_children():
		if state is State:
			states[state.name.to_lower()] = state
			state.change_state.connect(_on_change_state)
	
func setup_states(actor, p_data):
	for state in get_children():
		if state.has_method("_setup_state"):
			state._setup_state(actor, p_data)
	_set_state('idle')
	

func _process(delta):
	if current_state:
		current_state._update(delta)

func _physics_process(delta):
	if current_state:
		current_state._physics_update(delta)

func _set_state(new_state_name : String):
	var new_state = states.get(new_state_name.to_lower())
	
	if not new_state:
		push_warning("State Machine: State ", new_state_name, " not found.")
		return
		
	if current_state:
		previous_state = current_state
		previous_state._exit_state()
		
	current_state = new_state
	current_state._enter_state()
	state_changed.emit(new_state)

func _on_change_state(new_state : String):
	_set_state(new_state)
	#print_rich("[color=yellow]Transition to: ", new_state, " from: ", current_state.name, "[/color]")
	#print_stack()

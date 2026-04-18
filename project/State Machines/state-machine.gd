extends Node
class_name StateMachine

var states = {}

var previous_state : State
var current_state : State

signal change_animation(new_animation : String)
signal state_changed(new_state)

func _ready():
	for state in get_children():
		if state is State:
			states[state.name.to_lower()] = state
			state.change_animation.connect(_on_change_animation)
			state.change_state.connect(_on_change_state)

func _process(delta):
	if current_state:
		current_state._update(delta)

func _physics_process(delta):
	if current_state:
		current_state._physics_update(delta)

func _set_state(new_state : String):
	if not states[new_state] is State: return
	
	if current_state:
		previous_state = current_state
		previous_state._exit_state()
		
	current_state = states[new_state]
	current_state._enter_state()
	state_changed.emit(new_state)

func _on_change_state(new_state : String):
	if new_state in states:
		_set_state(new_state)
	#print_rich("[color=yellow]Transition to: ", new_state, " from: ", current_state.name, "[/color]")
	#print_stack()

func _on_change_animation(new_animation : String):
	change_animation.emit(new_animation)

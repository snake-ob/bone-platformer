# Punch Interface - child of State
extends Node

@onready var state = get_parent()

func _physics_update(delta):
	if not state.active: return
	
	var punch_input = state.ref.input.consume_punch()
	
	var next_state = state.ref.punching.request_punch(punch_input)
		
	if next_state != "":
		state.change_state.emit(next_state)

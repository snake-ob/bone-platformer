extends Node
class_name InputController

# --- Movement ---
var move_axis: float = 0.0
var jump_requested: bool = false
var jump_held: bool = false
var is_crouching: bool = false

# --- Combat ---
var punch_requested: bool = false
var punch_start_time: float = 0.0
var punch_held: bool = false
var buffered_punch

func _input(event):
	if event.is_action_pressed("ui_jump"):jump_requested = true
	if event.is_action_released("ui_jump"): jump_requested = false
	
	if event.is_action_pressed("ui_punch"): _handle_punch_press()
	if event.is_action_released("ui_punch"): _handle_punch_release()

func _process(delta):
	move_axis = Input.get_axis("ui_left", "ui_right")

# --- Punch Handling ---

func _handle_punch_press():
	punch_requested = true
	if buffered_punch != null:
		punch_held = true

func _handle_punch_release():
	punch_held = false
# --- Consumption (called by states) ---
	
func consume_punch() -> Dictionary:
	var punch_data = {"requested": punch_requested,"is_held": punch_held}
	if punch_requested:
		punch_requested = false
	buffered_punch = null
	return punch_data

func consume_jump() -> bool:
	if jump_requested:
		jump_requested = false
		return true
	return false

func is_jump_held() -> bool:
	return Input.is_action_pressed("ui_jump")
	
#Controller holds input in a buffer
#PunchManager controls timing.
#Punch is thrown. On frame 1 The punch manager takes it and says " this is jab"
#Punch 2 is thrown. It sits in a buffer until the PunchManager is ready to call it.
#Hold is default. On release, hold becomes false
#PunchManager clears the buffer on combo reset

# I think PunchRequested needs a rework. PunchRequested resets with every consumption
# This currently kills held punch combos

extends Node
class_name InputController

# --- Settings ---
@export var hold_threshold: float = 0.25

# --- Movement ---
var move_axis: float = 0.0
var jump_requested: bool = false
var jump_held: bool = false

# --- Combat ---
var press_start_time: float = 0.0
var is_holding: bool = false
var punch_requested: bool = false
var punch_held: bool = false

# -- Timers --
@onready var hold_timer: Timer = $HoldTimer


func _input(event):
	if event.is_action_pressed("ui_jump"):
		jump_requested = true
	
	if event.is_action_released("ui_jump"):
		jump_requested = false
	
	if event.is_action_pressed("ui_punch"):
		_handle_punch_press()
	
	if event.is_action_released("ui_punch"):
		_handle_punch_release()

func _process(delta):
	move_axis = Input.get_axis("ui_left", "ui_right")
	if Input.is_action_just_pressed("ui_jump"):
		jump_held = true
		
# --- Punch Handling ---

func _handle_punch_press():
	punch_requested = true
	is_holding = true
	press_start_time = Time.get_ticks_msec()
	hold_timer.start()

func _handle_punch_release():
	var duration = (Time.get_ticks_msec() - press_start_time) / 1000
	punch_held = duration >= hold_threshold
	is_holding = false

# --- Consumption (called by states) ---

func consume_punch() -> Dictionary:
	var punch_data = {"requested": punch_requested, "held": punch_held}
	if punch_requested:
		punch_requested = false
		hold_timer.stop()
	return punch_data

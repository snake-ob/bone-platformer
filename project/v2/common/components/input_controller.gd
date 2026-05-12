extends Node
class_name InputController

# --- Settings ---
@export var hold_threshold: float = 0.25
@export var combo_time: float = 0.6

# --- Movement ---
var move_axis: float = 0.0
var jump_requested: bool = false
var jump_held: bool = false
var is_crouching: bool = false

# --- Combat ---
var press_start_time: float = 0.0
var is_holding: bool = false
var punch_requested: bool = false
var punch_held: bool = false
var combo_step: int = 0

# -- Timers --
@onready var hold_timer: Timer = $HoldTimer
@onready var combo_timer: Timer

func _ready() -> void:
	combo_timer = Timer.new()
	add_child(combo_timer)
	combo_timer.one_shot = true
	combo_timer.timeout.connect(_on_combo_timeout)

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
	is_holding = true
	press_start_time = Time.get_ticks_msec()
	hold_timer.start()

func _handle_punch_release():
	var duration = (Time.get_ticks_msec() - press_start_time) / 1000
	punch_held = duration >= hold_threshold
	is_holding = false

# --- Consumption (called by states) ---

func _on_combo_timeout():
	reset_combo()

func reset_combo():
	combo_step = 0
	combo_timer.stop()
	
func consume_punch() -> Dictionary:
	var punch_data = {"requested": punch_requested,"held": punch_held, "combo": combo_step}
	if punch_requested:
		punch_requested = false
		hold_timer.stop()
	return punch_data
	
func advance_combo():
	combo_step += 1
	combo_timer.start(combo_time)

func consume_jump() -> bool:
	if jump_requested:
		jump_requested = false
		return true
	return false

func is_jump_held() -> bool:
	return Input.is_action_pressed("ui_jump")

extends Node
class_name PunchManager

@export var punch_buffer: float = 0.5
@export var cross_buffer: float = 0.6
@export var hold_threshold: float = 0.3

var recovery_timer: Timer
var cross_timer: Timer
var can_punch: bool = true
var combo_step: int = 0

var buffered_punch = null

func _ready():
	recovery_timer = Timer.new()
	add_child(recovery_timer)
	recovery_timer.one_shot = true
	recovery_timer.timeout.connect(func(): can_punch = true)
	cross_timer = Timer.new()
	add_child(cross_timer)
	cross_timer.one_shot = true
	cross_timer.timeout.connect(func(): combo_step = 0)
	
func request_punch(punch) -> String:
	if punch.requested:
		buffered_punch = punch
		
	if buffered_punch and can_punch:
		var punch_data = buffered_punch
		buffered_punch = null
		return _calculate_punch(punch_data)

	return ""
	
func _calculate_punch(punch) -> String:
	cross_timer.start(cross_buffer)
	var new_state = ""
	var is_held = punch.is_held
	
	match combo_step:
		0:
				new_state = "jab"
				combo_step += 1
		1:
			if is_held:
				new_state = "powercross"
			else:
				new_state = "cross"
				combo_step +=1
		2:
			if is_held:
				new_state = "hook"
				combo_step = 0
			else:
				new_state = "jab"
				combo_step = 1

	if new_state != "":
		can_punch = false
		recovery_timer.start(punch_buffer)
	
	return new_state

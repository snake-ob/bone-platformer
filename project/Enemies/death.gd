extends State

@export var playerDetection : Node
var death_time : Timer

func _ready():
	death_time = Timer.new()
	add_child(death_time)
	death_time.one_shot = true
	death_time.timeout.connect(_death_timeout)

func _enter_state():
	change_animation.emit("death")
	death_time.start(0.3)

func _exit_state():
	death_time.stop()

func _physics_update(delta):
	apply_gravity(actor, delta)

func _death_timeout():
	actor.queue_free()
	

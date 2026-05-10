extends CharacterBody2D
class_name Enemy

@onready var body = $Body
@onready var StateMachine = $StateMachine
@onready var Sprite = $Body/AnimatedSprite2D
@onready var softCollision = $SoftCollision


var current_direction : int
var new_direction: float:
	set(value):
		current_direction = sign(value)
		body.scale.x = current_direction

var player : Node
var current_state : String
var in_player_range: bool

func _ready():
	if StateMachine:
		StateMachine.change_animation.connect(_on_change_animation)
		StateMachine.state_changed.connect(_on_state_changed)
		for state in StateMachine.get_children():
			state.set_actor(self)
	
func _physics_process(delta):
	move_and_slide()
	check_colliding(delta)

func _on_change_animation(new_animation):
	Sprite.play(new_animation)

func connect_player(new_player):
	player = new_player
	for state in StateMachine.get_children():
		state.set_player(player)

func set_initial_state(new_state : String):
	StateMachine._set_state(new_state)
	
func check_colliding(delta):
	if softCollision.has_overlapping_areas():
		#if current_state == "idle" || current_state == "chase":
		velocity.x += softCollision.get_push_vector().x * delta * 150
			
func _on_state_changed(new_state : String):
	current_state = new_state

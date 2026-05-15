extends Node
class_name State

signal change_state(new_state)

var actor : Node
var player : Node
var ref : Reference
var active: bool = false
var children

func _ready():
	if self.get_child_count() > 0:
		children = self.get_children()

func _enter_state():
	pass
	
func _exit_state():
	pass

func _update(delta):
	pass

func _physics_update(delta):
	pass
	
func _setup_state(p_actor, p_data):
	actor = p_actor
	ref = p_data

func _reset_handlers():
	for child in children:
		if child.has_method('_reset'):
			child._reset()

extends CharacterBody2D

@onready var ref: Reference = $Reference

# PlayerV2
func _ready():
	ref.actor = self
	ref.physics = $PhysicsHandler
	ref.input = $InputController
	ref.body = $Body
	ref.animation = $Body/AnimationPlayer
	ref.stats = $Stats
	
	setup_nodes(self)
	$StateMachine.setup_states(self, ref)
	
func setup_nodes(p_node: Node) -> void:
	for child in p_node.get_children():
		if child.has_method("_setup"):
			child._setup(self)
		
		if child.get_child_count() > 0:
			setup_nodes(child)

func _physics_process(delta):
	move_and_slide()

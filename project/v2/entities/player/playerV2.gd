extends CharacterBody2D

# PlayerV2
func _ready():
	setup_nodes(self)
	setup_states(self, $Visuals/AnimationPlayer, $Stats, $InputController)
	
func setup_nodes(p_node: Node) -> void:
	for child in p_node.get_children():
		if child.has_method("_setup"):
			child._setup(self)
		
		if child.get_child_count() > 0:
			setup_nodes(child)

func setup_states(p_node: Node, p_visuals: AnimationPlayer, p_stats: StatsComponent, p_input: InputController):
	for child in p_node.get_children():
		if child.has_method("_setup_state"):
			child._setup_state(self, p_visuals, p_stats, p_input)
		
		if child.get_child_count() > 0:
			setup_states(child, p_visuals, p_stats, p_input)

func _physics_process(delta):
	move_and_slide()

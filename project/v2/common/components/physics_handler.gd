extends Node
class_name PhysicsHandler

@export var gravity_multiplier: float = 1

var actor: Node2D

var gravity: float = 980
var friction: float = 0.1

# --- State Controlled Variables ---
var is_gravity_enabled: bool = true
var is_friction_enabled: bool = true

func _setup(p_actor: Node2D):
	actor = p_actor
	
func _physics_process(delta):
	if is_gravity_enabled and not actor.is_on_floor():
		actor.velocity.y += gravity * gravity_multiplier * delta
		
	if is_friction_enabled and actor.is_on_floor():
		actor.velocity.x = move_toward(actor.velocity.x, 0, friction * delta)

func get_world_data(p_data: WorldData):
	gravity = p_data.gravity

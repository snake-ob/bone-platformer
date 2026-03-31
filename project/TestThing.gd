extends RigidBody2D

@onready var softCollision = $SoftCollision

var velocity = Vector2.ZERO

func _ready():
	center_of_mass_mode = RigidBody2D.CENTER_OF_MASS_MODE_CUSTOM
	set_center_of_mass(Vector2(0, 8))
	
func _physics_process(delta):
	if !sleeping:
		if soft_collision_check(delta):
			position += velocity

func interacted(force):
	apply_central_impulse(force)

func soft_collision_check(delta):
	if softCollision.is_colliding():
		velocity.x += softCollision.get_push_vector().x * delta
		return true
	else: return false
		

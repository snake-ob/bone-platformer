extends Resource
class_name MovementData

@export_group("Horizontal Movement")
@export var max_speed: float = 300.00
@export var acceleration: float = 1500.00
@export var friction: float = 1200.0

@export_group("Weights & Feel")
@export var mass: float = 1.0
@export var gravity_scale: float = 1.0

@export_group("Jumping")
@export var jump_vert: float = 4.0
@export var jump_force: float = 10

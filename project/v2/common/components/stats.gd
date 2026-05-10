extends Node
class_name StatsComponent

@export var movement_data: MovementData
@export var max_health: float = 100.0

var current_health: float
var current_stamina: float

signal health_changed(new_health: float)
signal health_depleted

func _ready():
	current_health = max_health
	
func take_damage(amount: float):
	current_health -= amount
	health_changed.emit(current_health)
	if current_health <= 0:
		health_depleted.emit()

extends Area2D
class_name HitBox

var actor: Node2D

@export var hit_data: HitData

func _setup(p_actor: Node2D):
	actor = p_actor
	
func _ready() -> void:
	area_entered.connect(_on_area_entered)
	
func _on_area_entered(area: Area2D) -> void:
	var hurtbox = area as HurtBox
	
	if hurtbox.has_method("take_hit"):
		var dynamic_data = hit_data.duplicate()
		dynamic_data.attacker_pos = actor.global_position
		hurtbox.take_hit(dynamic_data)

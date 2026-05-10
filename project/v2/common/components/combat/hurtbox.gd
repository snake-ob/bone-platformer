extends Area2D
class_name HurtBox

var actor: Node2D

signal hit_received(data: HitData)

func _setup(p_actor: Node2D):
	actor = p_actor

func take_hit(p_data: HitData) -> void:
	hit_received.emit(p_data)

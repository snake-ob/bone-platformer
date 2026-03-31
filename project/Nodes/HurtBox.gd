extends Area2D
class_name HurtBox

signal take_hit(force, damage)

func taken_hit(force, damage):
	take_hit.emit(force, damage)

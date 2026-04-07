extends Area2D
class_name HurtBox

signal take_hit(force, damage)
signal take_stun(force, damage)
signal take_slam(force, damage)

func taken_hit(force, damage):
	take_hit.emit(force, damage)

func taken_stun(force, damage):
	take_stun.emit(force, damage)

func taken_slam(force, damage):
	take_slam.emit(force, damage)

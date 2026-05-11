extends Node

var actor: Node2D
var current_tile: Vector2i

signal tile_entered(actor, collision_tile, collider)
signal tile_exited(actor)

func _setup(p_node: Node2D) -> void:
	actor = p_node

func _physics_process(delta):
	var collision = actor.get_last_slide_collision()
	
	if $FloorRay.is_colliding():
		var point = $FloorRay.get_collision_point()
		var normal = $FloorRay.get_collision_normal()
		var collider = $FloorRay.get_collider()
		
		if collider is TileMapLayer:
			var no_states = ['idle', 'jab', 'cross', 'hook']
			var current_state = $StateMachine.current_state.to_string()
			if current_state in no_states:
				pass
			var collision_tile = collider.local_to_map(collider.to_local(point))
			if collision_tile != current_tile:
				tile_entered.emit(actor, collision_tile, collider)
			current_tile = collision_tile
	else:
		tile_exited.emit(actor)

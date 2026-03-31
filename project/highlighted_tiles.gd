extends TileMapLayer

@export var player: CharacterBody2D
@export var highlight_tile_id: Vector2i = Vector2i(0, 0) # Your "glow" tile

var source_id

func _ready():
	# Connect the player's signals to our local functions
	player.tile_collided.connect(_on_player_tile_collided)
	player.tile_exited.connect(_on_player_tile_exited)
	source_id = tile_set.get_source_id(0)

func _on_player_tile_collided(point: Vector2, normal: Vector2, collider: Node2D):
	clear()
	
	if collider is TileMapLayer:
		# Convert collision point to map coordinates
		var pos = point - (normal * 4)
		var center = collider.local_to_map(collider.to_local(pos))
		
		# Determine if we are on a floor or wall
		var axis = Vector2i(0, 1) if abs(normal.x) > abs(normal.y) else Vector2i(1, 0)
		
		_draw_gradient(center, axis)

func _on_player_tile_exited():
	clear()

func _draw_gradient(center: Vector2i, axis: Vector2i):
	# Center (Alpha handled by Node Modulate or separate layers)
	set_cell(center, 0, highlight_tile_id)
	
	# Neighbors
	for i in range(1, 3):
		var atlas_coords = highlight_tile_id + Vector2i(0,1)
		set_cell(center + (axis * i), source_id, atlas_coords)
		set_cell(center - (axis * i), source_id, atlas_coords)

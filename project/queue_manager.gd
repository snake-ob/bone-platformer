extends Node2D
# Every 0.5 seconds, check new player position (if changed, recalculate queue)
# Active Slots = {ent: Slime, tile: 1}
# Empty Slots = [0,1,2]
# 

class Slot:
	var active: bool = false
	var held_by: Enemy = null
	var reserved_by: Enemy = null
	var centre_x: int
	var pos_index: int = 0
	
	func is_available():
		return held_by == null and reserved_by == null
		
var slots: Array

func _draw():
	for slot in slots:
		draw_circle(Vector2(slot.centre_x - global_position.x, 0), 5.0, Color.INDIAN_RED)

func _ready():
	for i in range(-3,4):
		if i == 0: continue
		var new_slot = Slot.new()
		new_slot.pos_index = i
		slots.append(new_slot)

func _queue_timeout():
	pass
	
func refresh_tiles(new_tile :Vector2i, tile_map: TileMapLayer):
	var centre_tile_pos = tile_map.to_global(tile_map.map_to_local(new_tile))
	var tile_width = tile_map.tile_set.tile_size.x
	
	for Slot in slots:
		var offset_x = Slot.pos_index * tile_width
		Slot.centre_x = centre_tile_pos.x + offset_x


func calculate_queue():
	pass
	

extends Node2D

func get_cell_center_position(pos):
	var size = $TileMap.get_cell_size()
	var cell = $TileMap.world_to_map(pos) * size
	return cell + size / 2

func is_wall(pos):
	var world = $TileMap.world_to_map(pos)
	var tile = $TileMap.get_cell(world.x, world.y)
	return tile
	
func broke_tile(pos):
	var world = $TileMap.world_to_map(pos)
	$TileMap.set_cell(world.x, world.y, 1)
#func _process(delta):
#	pass

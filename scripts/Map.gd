extends Node2D
# Tile = 0 parade,
# Tile = 1 chão
# Tile = 2 bloco quebravel
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

func get_tile(coordenate):
	return $TileMap.get_cell(coordenate.x, coordenate.y)

func get_directions_without_walls(pos):
	var coordenate = $TileMap.world_to_map(get_cell_center_position(pos))
	var possibles_orientations = [Vector2(coordenate.x+1, coordenate.y), Vector2(coordenate.x-1, coordenate.y), Vector2(coordenate.x, coordenate.y+1), Vector2(coordenate.x, coordenate.y-1)]
	var free = []
	for i in range(possibles_orientations.size()):
		var tile = get_tile(possibles_orientations[i])
		if tile != 0 and tile != 2:
			var coord = possibles_orientations[i]
			free.append(coord - coordenate)
	return free

func get_enemies_positions(number_of_enemies, blockeds):
	var open = $TileMap.get_used_cells_by_id(1).duplicate()
	var size = $TileMap.get_cell_size()
	var positions = []
	for i in range(blockeds.size()-1):
		var index = open.bsearch(blockeds[i])
		open.remove(index)
	
	for i in range(number_of_enemies - 1):
		var element = get_random_of_array(open)
		var index = open.bsearch(element)
		open.remove(index)
		positions.append((element*size) + (size / 2) )
		
	return positions

func get_random_of_array(arr):
	var selected = arr[ randi() % arr.size()]
	return selected

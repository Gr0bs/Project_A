extends TileMap

enum { EMPTY = -1, PLAYER, OBSTACLE, ENEMY}

func _ready():
	# Get all the child from GRID and 
	for child in get_children():
		print(child)
		# Set position to the cell 
		set_cellv(world_to_map(child.position), child.type)

func get_cell_pawn(coordinates):
	for child in get_children():
		if world_to_map(child.position) == coordinates:
			return child
	
func request_move(pawn, direction):
	var cell_start = world_to_map(pawn.position)		# GET THE START POSITION FROM YOUR PLAYER
	var cell_target = cell_start + direction 			# SET THE TARGET WHERE THE PLAYER IS GOING
	
	var cell_target_type = get_cellv(cell_target)
	match cell_target_type:
		EMPTY:
			return update_pawn_position(pawn, cell_start,cell_target) 
		ENEMY:
			var pawn_name = get_cell_pawn(cell_target).name
			print("Cell contains ENEMY")
			

func update_pawn_position(pawn, cell_start, cell_target):
	set_cellv(cell_target, pawn.type)			# Attribute the pawn type to the cell target
	set_cellv(cell_start, EMPTY)				# Set the cell start EMPTY
	return map_to_world(cell_target) + cell_size /2			# RETURN THE NEW POSITION OF THE CELL BY THE TOP LEFT 

extends Node
class_name Pathfinder

onready var tilemap = get_parent()
var astar = AStar2D.new()
var room_size := Vector2.ZERO

func _ready() -> void:
	
	room_size = tilemap.get_used_rect().size
	_init_astar()


func _init_astar() -> void:
	var cells_array = tilemap.get_used_cells()
	
	# ADD EVERY CELLS "GROUND" AS A POINT IN THE A*
	for cell in cells_array:
		var tile_id = tilemap.get_cellv(cell)
		var tile_name = tilemap.tile_set.tile_get_name(tile_id)
		
		if tile_name == "Ground":
			# CREATE A UNIQUE ID FOR THE POINT
			var point_id = _generate_point_id(cell)
			astar.add_point(point_id, cell)
	
	_astar_connect_point(cells_array)


func _astar_connect_point(point_array: Array, connect_diagonals: bool = false) -> void:
	for point in point_array:
		var point_index = _generate_point_id(point)
		
		if !astar.has_point(point_index):
			continue
		
		# GET NEIGBOOR POINT AND CONNECT 
		for x_offset in range(3):
			for y_offset in range(3):
				
				if !connect_diagonals && x_offset in [0, 2] && y_offset in [0, 2]:
					continue
				
				# GET NEAR POINT (-1 is for the range from -1 to 1) 
				var point_relative = Vector2(point.x + x_offset - 1, point.y + y_offset -1)
				var point_rel_id = _generate_point_id(point_relative)
				
				if point_relative == point or !astar.has_point(point_rel_id):
					continue
				
				astar.connect_points(point_index, point_rel_id)

func _generate_point_id(cell: Vector2) -> int:
	return int(abs(cell.x + room_size.x * cell.y))


func find_path(from: Vector2, to: Vector2) -> PoolVector2Array:
	var from_cell_id = _generate_point_id(from)
	var to_cell_id = _generate_point_id(to)
	
	var point_path = astar.get_point_path(from_cell_id, to_cell_id)
	
	return point_path
	
	


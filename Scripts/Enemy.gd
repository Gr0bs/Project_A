extends Area2D

var obstacle
var pathfinder
var player
var tile_size := 64
var speed := 0.3
var map_pos = Vector2(0,0) setget set_actor_map_pos, get_actor_map_pos
var next_move : String
var next_pos : Vector2


var direction = {
	"up" : Vector2.UP,
	"right": Vector2.RIGHT,
	"down": Vector2.DOWN,
	"left": Vector2.LEFT
}

############## STATE #################
func set_actor_map_pos(value: Vector2) -> void:
	if value != map_pos:
		map_pos = obstacle.world_to_map(value)

func get_actor_map_pos() -> Vector2:
	return map_pos



############ BUILT-IN ################

func _ready() -> void:
	$Line2D.set_as_toplevel(true)	

############# LOGIC ##################

func move() -> void:
	if !pathfinder.free_tile(next_pos):
		return
	
	var last_pos = get_actor_map_pos()
	$Tween.interpolate_property(
		self,
		"position",
		position,
		position + direction[next_move] * tile_size,
		speed, 
		$Tween.TRANS_CUBIC,
		$Tween.EASE_IN_OUT
		)
	$Tween.start()
	set_actor_map_pos(position + direction[next_move] * tile_size)
	pathfinder.update_point(last_pos, get_actor_map_pos())
	$Line2D.clear_points()
	
	if get_actor_map_pos() != player.get_map_pos():
		get_next_move(get_actor_map_pos(), player.get_map_pos())
		


func get_next_move(from: Vector2, to: Vector2) -> void:
	var path_point = pathfinder.find_path(from, to)
	for point in path_point:
		$Line2D.add_point(obstacle.map_to_world(point) + Vector2.ONE * 32)
	
	var dir
	for d in direction:
		if get_actor_map_pos() + direction[d] == path_point[1]:
			dir = d
	
	var rotation_arrow
	match(dir):
		"up": 
			rotation_arrow = 180
		"down":
			rotation_arrow = 0
		"left": 
			rotation_arrow = 90
		"right": rotation_arrow = -90

	$ArrowSprite.rotation_degrees = rotation_arrow
	next_move = dir
	next_pos = path_point[1]
	






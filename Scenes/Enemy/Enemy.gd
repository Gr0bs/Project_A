extends Area2D

var obstacle
var tile_size := 64
var speed := 0.3
var map_pos = Vector2(0,0) setget set_actor_map_pos, get_actor_map_pos
var next_move : String


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
	EVENTS.connect("movement", self, "_on_player_movement")
		

############# LOGIC ##################

func _move(dir: String) -> void:
	$RayCast2D.set_cast_to(direction[dir] * tile_size)
	$RayCast2D.force_raycast_update()
	
	if !$RayCast2D.is_colliding():
		$Tween.interpolate_property(
			self,
			"position",
			position,
			position + direction[dir] * tile_size,
			speed, 
			$Tween.TRANS_CUBIC,
			$Tween.EASE_IN_OUT
			)
		$Tween.start()
		obstacle.set_cellv(get_actor_map_pos(), -1)
		set_actor_map_pos(position + direction[dir] * tile_size)
		obstacle.set_cellv(get_actor_map_pos(), 20)


func get_next_move(pos: Vector2) -> void:
	var is_empty = 0
	var dir 
	
	while is_empty != -1:
		dir = direction.keys()[randi() % direction.size()]
		var case_coord = get_actor_map_pos() + direction[dir]
		print(obstacle.get_cellv(case_coord))
		is_empty = obstacle.get_cellv(case_coord)
	
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


############ SIGNAL #################

func _on_player_movement() -> void:
	var dir_keys = direction.keys()
	_move(next_move)
	get_next_move(get_actor_map_pos())



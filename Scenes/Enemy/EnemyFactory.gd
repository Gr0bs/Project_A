extends Node2D

onready var obstacle = owner.get_node("./Obstacle")
var enemy_scene = preload("res://Scenes/Enemy/Enemy.tscn")
export var nbr_enemy_spawn := 2
var start_pos = [Vector2(5,3), Vector2(7,6)]


########### BUILD-IN #############
func _ready() -> void:
	randomize()
	EVENTS.connect("get_chest_first", self, "_on_get_chest_first")


########## LOGIC ###########
func _spawn_enemy() -> void:
	for i in nbr_enemy_spawn:
		var enemy = enemy_scene.instance()
		var world_pos = obstacle.map_to_world(start_pos[i])
		obstacle.set_cellv(start_pos[i], 20)
		enemy.position = Vector2(world_pos.x, world_pos.y)
		enemy.position += Vector2.ONE * 32
		owner.add_child(enemy)
		enemy.obstacle = obstacle
		enemy.set_actor_map_pos(enemy.position)
		enemy.get_next_move(start_pos[i])



##########  SIGNAL #########
func _on_get_chest_first() -> void:
	_spawn_enemy()


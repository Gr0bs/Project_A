extends Node2D

onready var obstacle = owner.get_node("Obstacle")
onready var player = owner.get_node("Player")
var enemy_scene = preload("res://Scenes/Enemy/Enemy.tscn")
export var nbr_enemy_spawn := 2
export var start_pos = PoolVector2Array()
var enemies_box = []

########### BUILD-IN #############
func _ready() -> void:
	randomize()
	EVENTS.connect("get_chest_first", self, "_on_get_chest_first")
	EVENTS.connect("movement", self, "_on_player_movement")


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
		enemy.player = player
		enemy.pathfinder = owner.get_node("Background/Pathfinder")
		enemy.set_actor_map_pos(enemy.position)
		enemy.get_next_move(start_pos[i], player.get_map_pos())
		enemies_box.append(enemy)


##########  SIGNAL #########
func _on_get_chest_first() -> void:
	_spawn_enemy()


############ SIGNAL #################
func _on_player_movement() -> void:
	for enemy in enemies_box:
		enemy.move()

		if player.get_map_pos() == enemy.get_actor_map_pos() :
			EVENTS.emit_signal("game_over")

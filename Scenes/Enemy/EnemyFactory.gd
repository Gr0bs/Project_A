extends Node2D

onready var tilemap = owner.get_node("./TileMap")
var enemy_scene = preload("res://Scenes/Enemy/Enemy.tscn")

func _ready() -> void:
	randomize()
	EVENTS.connect("get_chest", self, "_on_get_chest")

func _on_get_chest() -> void:
	for num in range(2):
		var enemy = enemy_scene.instance()
		var random_pos = Vector2(randi() % 11 + 3, randi() % 4 + 2)
		var used_cell = tilemap.get_used_cells()
		var world_pos = tilemap.map_to_world(random_pos)
		tilemap.set_cellv(random_pos, 20)
		enemy.position = Vector2(world_pos.x + 32, world_pos.y + 32)
		owner.add_child(enemy)

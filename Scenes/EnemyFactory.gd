extends Node2D

var enemy = preload()

func _ready() -> void:
	EVENTS.connect("get_chest", self, "_on_get_chest")


func _on_get_chest() -> void:
	var 

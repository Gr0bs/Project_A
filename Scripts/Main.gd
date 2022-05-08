extends Node2D

func _ready() -> void:
	EVENTS.connect("game_over", self, "_on_game_over")


func _on_game_over() -> void:
	$UI/TITLE.set_visible(true)
	$UI/TITLE.text = "GAME OVER"

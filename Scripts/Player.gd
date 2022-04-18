extends Area2D

var tile_size := 64
var speed := 0.3
var has_chest := false
var can_move := true

var case = preload("res://sprites/Ui/chest.png")

var inputs = {
	"ui_up" : Vector2.UP,
	"ui_right": Vector2.RIGHT,
	"ui_down": Vector2.DOWN,
	"ui_left": Vector2.LEFT
}


############ BUILT-IN ############

func _ready() -> void:
	$AnimatedSprite.play("Idle")
	position = position.snapped(Vector2.ONE * tile_size)
	position += Vector2.ONE * tile_size/2
	
func _unhandled_input(event):
	if $Tween.is_active():
		return
		
	for dir in inputs.keys():
		if event.is_action_pressed(dir) and can_move:
			_move(dir)
		elif event.is_action_pressed("ui_accept") and has_chest:
			_display_ui()
		elif event.is_action_pressed(dir) and has_chest:
			_drop_chest(dir)
			


############# LOGIC #############
func _display_ui() -> void:
	can_move = false
	var tilemap = owner.get_node("./TileMap")
	for dir in inputs:
		var case_coord = tilemap.world_to_map(position) + inputs[dir]
		if tilemap.get_cellv(case_coord) == -1:
			$CaseOverlay.set_cellv(inputs[dir], 0)



func _move(dir: String) -> void:
	$Raycast.set_cast_to(inputs[dir] * tile_size)
	$Raycast.force_raycast_update()
			
	if !$Raycast.is_colliding():
		$Tween.interpolate_property(
			self,
			"position",
			position,
			position + inputs[dir] * tile_size,
			speed, 
			$Tween.TRANS_CUBIC,
			$Tween.EASE_IN_OUT
			)
		$Tween.start()



func _drop_chest(dir: String) -> void:
	var Chest = get_node("/root/Main/Chest")
	Chest.visible = true
	Chest.position = position + (inputs[dir] * tile_size)
	$AnimatedSprite.play("Idle")
	can_move = true
	$CaseOverlay.clear()


################ SIGNAL FUNCTION ############## 
func _on_Player_area_entered(bodies):
	if bodies.get_name() == 'Chest':
		bodies.visible = false
		has_chest = true
		$AnimatedSprite.play("Chest")
		EVENTS.emit_signal("get_chest")

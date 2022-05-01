extends Area2D

var tile_size := 64
var speed := 0.3
var select_case := false
var authorised_drop = []
var first_carrying_chest = false
onready var obstacle = owner.get_node("./Navigation2D/Obstacle")

const CHEST_SCN = preload("res://Scenes/Objects/Chest.tscn")

var state = "Empty" setget set_state, get_state
var map_pos = Vector2(0,0) setget set_map_pos, get_map_pos

var inputs = {
	"ui_up" : Vector2.UP,
	"ui_right": Vector2.RIGHT,
	"ui_down": Vector2.DOWN,
	"ui_left": Vector2.LEFT
}


############# ACCESSOR  ##################

func set_state(value: String) -> void:
	if value != state:
		state = value

func get_state() -> String:
	return state
	
func set_map_pos(value: Vector2) -> void:
	if value != map_pos:
		map_pos = value

func get_map_pos() -> Vector2:
	return map_pos


############ BUILT-IN ############

func _ready() -> void:
	$AnimatedSprite.play("Idle")
	position = position.snapped(Vector2.ONE * tile_size)
	position += Vector2.ONE * tile_size/2
	
func _unhandled_input(event):
	if $Tween.is_active():
		return
		
	for dir in inputs.keys():
		if event.is_action_pressed(dir) and not select_case:
			_move(dir)
			yield($Tween, "tween_completed")
			# MOVE ENEMY ONLY IF WE CARRY THE CHEST
			if get_state() == 'HasChest':
				EVENTS.emit_signal("movement")
		elif event.is_action_pressed("ui_accept") and get_state() == "HasChest":
			_display_ui()
		elif event.is_action_pressed(dir) and get_state() == "HasChest":
			if authorised_drop.has(dir):
				_drop_chest(dir)
			


############# LOGIC #############
func _display_ui() -> void:
	authorised_drop.clear()
	select_case = true
	
	for dir in inputs:
		var case_coord = get_map_pos() + inputs[dir]
		if obstacle.get_cellv(case_coord) == -1:
			authorised_drop.append(dir)
			$CaseOverlay.set_cellv(inputs[dir], 0)



func _move(dir: String) -> void:
	if owner.get_node_or_null("./Chest"):
		$RayCast2D.add_exception(owner.get_node("./Chest"))
		
	$RayCast2D.set_cast_to(inputs[dir] * tile_size)
	$RayCast2D.force_raycast_update()
	
	if !$RayCast2D.is_colliding():
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
		set_map_pos(obstacle.world_to_map(position) + inputs[dir])
		
		
		

func _drop_chest(dir: String) -> void:
	set_state("Empty")
	var Chest = CHEST_SCN.instance()
	Chest.position = position + (inputs[dir] * tile_size)
	owner.add_child(Chest)
	$AnimatedSprite.play("Idle")
	select_case = false
	$CaseOverlay.clear()


################ SIGNAL FUNCTION ############## 
func _on_Player_area_entered(bodies):
	yield($Tween,"tween_completed")
	if bodies.get_name() == 'Chest':
		bodies.queue_free()
		set_state("HasChest")
		$AnimatedSprite.play("Chest")
		if !first_carrying_chest:
			EVENTS.emit_signal("get_chest_first")
			first_carrying_chest = true

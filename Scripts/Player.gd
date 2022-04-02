extends "pawn.gd"

onready var Grid = get_parent()

var direction = Vector2.ZERO

func _process(delta):
	var target_position = Grid.request_move(self, direction)
	if target_position:
		move_to(target_position)

func _input(event):
	direction =  Vector2(
		int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left")),
		int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	)


func move_to(target_position):
	set_process(false)
	$AnimationPlayer.play("Walk")
	
	# MOVE THE NODE TO THE TARGET CELL INSTANTLY
	# AND ANIMATION THE SPRITE
	
	var move_direction = target_position - position 	# GET COORDONATE OF NEW POSITION
	
	$Tween.interpolate_property(
		self,
		"position",
		 position, 
		target_position,
		$AnimationPlayer.current_animation_length,
		Tween.TRANS_LINEAR, Tween.EASE_IN
		)
	$Tween.start()
	
	yield($AnimationPlayer, "animation_finished")		# STOP THE EXECUTION UNTIL THE ANIMATION FINISHED
	set_process(true)

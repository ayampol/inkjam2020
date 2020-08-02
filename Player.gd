extends KinematicBody2D

const ACCELERATION = 500
const MAX_SPEED = 100
const FRICTION = 500

var velocity = Vector2.ZERO
var accepting_input = true

func _physics_process(delta):
	var input_vector = Vector2.ZERO
	if accepting_input:
		input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
		input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		
	velocity = move_and_slide(velocity)


# Called when the node enters the scene tree for the first time.



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_DialogueUI_dialogue_ui_open(is_open):
	accepting_input = !is_open

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

func _input(event):
	var last_collision = null
	if get_slide_count() - 1 >= 0:
		last_collision = get_slide_collision(get_slide_count()-1)
	if is_instance_valid(last_collision):
		if event.is_action_pressed("ui_accept"):
			var collider_knot = last_collision.get_collider().get("knot")
			if collider_knot != null:
				var ink_runner = $"../../InkRunner"
				ink_runner.select_knot(collider_knot)
				ink_runner.show_next_dialogue()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_DialogueUI_dialogue_ui_open(is_open):
	set_process_input(!is_open)
	accepting_input = !is_open

extends KinematicBody2D

const ACCELERATION = 500
const MAX_SPEED = 200
const FRICTION = 500

const INKRUNNER = preload("res://InkRunner.gd")

var velocity = Vector2.ZERO
var accepting_input = true

onready var interactArea = $InteractArea

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
	print(interactArea.get_overlapping_bodies())
	var overlapping = interactArea.get_overlapping_bodies()
	if (!overlapping.empty()):
		var last_overlap = overlapping.back()
		if event.is_action_pressed("ui_accept"):
			var overlap_knot = last_overlap.get("knot")
			if (overlap_knot):
				var ink_runner = $"../../InkRunner"
				ink_runner.select_knot(overlap_knot)
				ink_runner.show_next_dialogue()
	
#	var last_collision = null
#	if get_slide_count() - 1 >= 0:
#		last_collision = get_slide_collision(get_slide_count()-1)
#	if is_instance_valid(last_collision):
#		if event.is_action_pressed("ui_accept"):
#			var collider_knot = last_collision.get_collider().get("knot")
#			if collider_knot != null:
#				var ink_runner = $"../../InkRunner"
#				ink_runner.select_knot(collider_knot)
#				ink_runner.show_next_dialogue()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_DialogueUI_dialogue_ui_open(is_open):
	set_process_input(!is_open)
	accepting_input = !is_open

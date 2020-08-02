extends Control

var active_choice = null

onready var diag_text = $DialogueBoxPanel/DialogeBoxMarginContainer/DialogueBoxText
onready var choice_box = $ChoiceListVBox
onready var name_tag = $NameTag

signal dialogue_ui_open(is_open)
signal dialogue_next()
signal choice_made(index)

func show_dialogue():
	visible = true
	set_process_input(true)
	emit_signal("dialogue_ui_open", true)

func hide_dialogue():
	visible = false
	set_process_input(false)
	emit_signal("dialogue_ui_open", false)
	
func set_text(text):
	diag_text.bbcode_text = text
	
func set_label(label):
	if len(label) == 0:
		name_tag.text = ""
		name_tag.hide()
	else:
		name_tag.text = label
		name_tag.visible = true

func display_choices(choices):
	choice_box.set_choices(choices)
	choice_box.visible = true
	choice_box.set_process_input(true)
	set_process_input(false)

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process_input(false)
	choice_box.set_process_input(false)

func _input(event):
	if event.is_action_pressed("ui_accept"):
		emit_signal("dialogue_next")

func _on_ChoiceListVBox_selected(index):
	set_process_input(true)
	choice_box.set_process_input(false)
	choice_box.hide()
	emit_signal("choice_made", index)

extends VBoxContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var choices = []
var selection = 0

signal selected(index)

func set_choices(new_choices):
	choices = new_choices
	selection = 0
	_redraw()

func _input(event):
	if event.is_action_pressed("ui_down"):
		selection += 1
	elif event.is_action_pressed("ui_up"):
		if selection - 1 < 0:
			selection = len(choices) - 1
		else:
			selection -= 1
	elif event.is_action_pressed("ui_accept"):
		emit_signal("selected", selection)
		return
	_redraw()

func _redraw():
	for child in get_children():
		remove_child(child)
	for i in range(len(choices)):
		add_child(_mkitem(choices[i], i == selection % len(choices)))

func _mkitem(text, is_selected = false):
	var outer_panel = PanelContainer.new()
	var flat_box = StyleBoxFlat.new()
	if !is_selected:
		flat_box.set_bg_color(Color(0.2, 0.2, 0.2, 0.5))
	else:
		flat_box.set_bg_color(Color(0.3, 0.3, 0.3, 1))
	outer_panel.add_stylebox_override("panel", flat_box)
	var label = Label.new()
	label.text = text
	var font = DynamicFont.new()
	var font_data = DynamicFontData.new()
	font_data.set_font_path("res://FiraCode-Regular.ttf")
	font.set_font_data(font_data)
	font.set_size(6)
	label.add_font_override("font", font)
	var margin = MarginContainer.new()
	margin.add_constant_override("margin_top", 3)
	margin.add_constant_override("margin_bottom", 3)
	margin.add_constant_override("margin_left", 8)
	margin.add_constant_override("margin_right", 8)
	margin.add_child(label)
	outer_panel.add_child(margin)
	return outer_panel

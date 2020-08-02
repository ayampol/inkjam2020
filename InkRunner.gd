extends Node

onready var dialogue_ui = $"../UILayer/DialogueUI"

func select_knot(path):
	Ink.story.choose_path_string(path)

func show_next_dialogue():
	if Ink.story.can_continue:
		var txt = Ink.story.continue()
		var name_matcher = RegEx.new()
		name_matcher.compile("([^:]+):\\s(.*$)")
		var mb_match = name_matcher.search(txt)
		if mb_match:
			dialogue_ui.set_label(mb_match.get_string(1))
			dialogue_ui.set_text(mb_match.get_string(2))
		else:
			dialogue_ui.set_label("")
			dialogue_ui.set_text(txt)
		dialogue_ui.show_dialogue()
	elif Ink.story.current_choices.size() > 0:
		var acc = []
		for choice in Ink.story.current_choices:
			acc.push_back(choice.text)
		dialogue_ui.display_choices(acc)
	else:
		return false
	return true

func _on_DialogueUI_dialogue_next():
	var can_show_next = show_next_dialogue()
	if !can_show_next:
		dialogue_ui.hide_dialogue()

func _on_DialogueUI_choice_made(index):
	Ink.story.choose_choice_index(index)
	show_next_dialogue()

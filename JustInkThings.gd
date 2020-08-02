extends Node

var InkRuntime = load("res://addons/inkgd/runtime.gd")
var Story = load("res://addons/inkgd/runtime/story.gd")

var story

func _ready():
	call_deferred("_init_story")

func _exit_tree():
	call_deferred("_remove_runtime")

func _init_story():
	_add_runtime()
	
	var ink_story = File.new()
	ink_story.open("res://story.json", File.READ)
	var content = ink_story.get_as_text()
	ink_story.close()
	story = Story.new(content)
	
func _add_runtime():
	InkRuntime.init(get_tree().root)


func _remove_runtime():
	InkRuntime.deinit(get_tree().root)

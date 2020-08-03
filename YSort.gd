extends YSort

# The People
onready var daveSprite = $dave
onready var jimSprite = $jimbo
onready var beckySprite = $becky
onready var steveSprite = $steve
onready var canvas = $CanvasModulate
onready var tween = $CanvasModulate/Tween
onready var ui = $"../UILayer"
onready var label = $"../UILayer/PanelContainer/RichTextLabel"
onready var fire = $fire
var copper #Not created until we have the cop
const copScene = preload("res://CopStatic2D.tscn")

# The Things
onready var watercooler = $WaterCoolerBody/watercooler
onready var box = $BoxNode2D/Sprite

# The Places
var office_location = {
	"dave": Vector2(494.846, 2.234),
	"becky" : Vector2(302.934, 1.667),
	"jim" :  Vector2(565.143, 2.227)
}

var death_location = {
	"steve" : Vector2(220.822, 20.243),
	"dave" : Vector2(169.78, 17.611)
}

var lunch_location = {
	"becky": Vector2(-14.608,31.613 )
}

# The Ink Listeners



# Control variables
var screenFaded = false;


# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _input(event):
	if event.is_action_pressed("ui_focus_next"):
		if (screenFaded == false):
			relocateOnProgress()
			screenFaded = true
		elif (screenFaded == true):
			screenFadeIn()
			screenFaded = false

		
func relocateOnProgress():
	# logic based on gone to shit/who's dead
	var time = 1
	tween.interpolate_property(canvas, "color", Color(1,1,1,1), Color(0,0,0,0),
			time,Tween.TRANS_QUAD,Tween.EASE_IN)
	tween.start()
	yield(tween,"tween_completed")
	#modifyPositions()
	var words = RichTextLabel.new()
	ui.add_child(words)
	words.set_text("Wow words")
	words.set_visible_characters(5)
#	screenFadeOut()
	thingsGoneToShit("hat", true)
	callCops("yeP", true)

func screenFadeOut():
	var time = 1
	tween.interpolate_property(canvas, "color", Color(1,1,1,1), Color(0,0,0,0),
			time,Tween.TRANS_QUAD,Tween.EASE_IN)
	tween.start()
	yield(tween,"tween_completed")

func screenFadeIn():
	var time = 1
	tween.interpolate_property(canvas, "color", Color(0,0,0,0), Color(1,1,1,1),
			time,Tween.TRANS_QUAD,Tween.EASE_IN)
	tween.start()

# This will figure out positions and set them
func modifyPositions():
	sendToOffices()
	
func sendToOffices():
	daveSprite.set_position(office_location["dave"])
	beckySprite.set_position(office_location["becky"])
	jimSprite.set_position(office_location["jim"])
	

func thingsGoneToShit(_variable_name, _new_value):
	watercooler.set_frame(1)
	box.set_frame(1)
	kill_steve()
	sendToOffices()
	
func warningSignCooler(_varName, _newVal):
	watercooler.set_frame(3)

func cautionTapeCooler():
	watercooler.set_frame(2)

func kill_steve():
	steveSprite.set_frame(1)
	steveSprite.set_position(death_location["steve"])

func cover_steve(_varname, _newVal):
	steveSprite.set_frame(2)
	
func callCops(_varName, _newVal):
	cautionTapeCooler()
	copper = copScene.instance()
	copper.position = death_location["dave"]
	add_child(copper)
	
func firewaveorno(_varName, newVal):
	fire.visible = newVal

func printTheHour(varName, newVal):
	label.text = str(newVal + 9) + ":00"

func beckyAtMicrowave(_varName, newVal):
	if newVal:
		beckySprite.set_position(lunch_location["becky"])
	else:
		beckySprite.set_position(office_location["becky"])
	
	


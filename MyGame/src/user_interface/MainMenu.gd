extends Control

onready var mainSettings = $MainContainer
onready var settings = $OptionsScreen
onready var confirm = $SureToQuit
onready var logo = $logo
onready var campfire = $FireSound
onready var forest = $ForestSound
onready var click = $Click

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	settings.hide()
	campfire.play()
	forest.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Exit_pressed():
	confirm.show()
	click.play()


func _on_Options_pressed():
	mainSettings.hide()
	logo.hide()
	settings.show()
	click.play()


func _on_GoBack_pressed():
	mainSettings.show()
	logo.show()
	settings.hide()
	click.play()


func _on_fullScreenToggle_pressed():
	OS.window_fullscreen = !OS.window_fullscreen
	click.play()
	


func _on_SureToQuit_confirmed():
	get_tree().quit()
	



func _on_Start_pressed():
	get_tree().change_scene("res://src/levels/Stages.tscn")

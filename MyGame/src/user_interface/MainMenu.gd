extends Control

onready var mainSettings = $MainContainer
onready var settings = $OptionsScreen
onready var confirm = $SureToQuit
onready var logo = $logo

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	settings.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Exit_pressed():
	confirm.show()


func _on_Options_pressed():
	mainSettings.hide()
	logo.hide()
	settings.show()


func _on_GoBack_pressed():
	mainSettings.show()
	logo.show()
	settings.hide()


func _on_fullScreenToggle_pressed():
	OS.window_fullscreen = !OS.window_fullscreen


func _on_SureToQuit_confirmed():
	get_tree().quit()

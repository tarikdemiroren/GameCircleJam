extends Control

onready var anim_pleya = $fader_player

signal health_changed(health)


func _on_Player_health_changed(health):
	emit_signal("health_changed", health)


func _on_Player_inevitable_death():
	anim_pleya.play("fade_in")
	

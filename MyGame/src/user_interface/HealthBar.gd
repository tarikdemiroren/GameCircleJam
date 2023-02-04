extends Control

onready var healthBar = $healthBar

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func animate_val(start, end):
	$Tween.interpolate_property(healthBar, "value", start, end, 0.4, Tween.TRANS_ELASTIC, Tween.EASE_OUT)
	$Tween.start()

func _on_PlayerScene_health_changed(health):
	animate_val(healthBar.value, health)
	healthBar.value = health

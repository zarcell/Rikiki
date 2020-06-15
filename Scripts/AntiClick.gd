extends Node2D

func _ready():
	visible = false

func start():
	visible = true
	$Timer.start(Global.animationSpeed * 0.8)

func _on_Timer_timeout():
	visible = false

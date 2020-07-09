extends Node2D

func _ready():
	visible = false

func open():
	visible = true
	$AnimationPlayer.play("PanelOpen")

extends Node2D

func _ready():
	visible = false

func open():
	visible = true
	$AnPlayer.play("PanelOpen")

func close():
	$AnPlayer.play("PanelClose")


func _on_Close_pressed():
	close()

extends Node2D

func _ready():
	self.visible = true
	get_parent().get_node("GamesPhase/Undo").visible = false

func move(target):
	var move_tween = get_node("move_tween")
	move_tween.interpolate_property(self, "position", position, target, Global.animationSpeed, Tween.TRANS_QUINT, Tween.EASE_OUT)
	move_tween.start()


func _on_FastMode_pressed():
	Global.fastGame = $Phase1Menu/FastMode/CheckBox.pressed
	Global.maximumLaps = 7
	$Phase1Menu/HBox2/NumberOfLaps.text = str(Global.maximumLaps)


func _on_StartWithMax_pressed():
	Global.startWithMax = $Phase1Menu/StartWihtMax/CheckBox.pressed

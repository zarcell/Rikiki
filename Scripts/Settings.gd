extends Node2D


func _ready():
	self.visible = true

func move(target):
	var move_tween = get_node("move_tween")
	move_tween.interpolate_property(self, "position", position, target, Global.animationSpeed, Tween.TRANS_QUINT, Tween.EASE_OUT)
	move_tween.start()


func _on_FastMode_pressed():
	Global.fastGame = $VBox/FastMode/CheckBox.pressed
	Global.maximumLaps = 7


func _on_StartWithMax_pressed():
	Global.startWithMax = $VBox/StartWihtMax/CheckBox.pressed


func _on_OneCards_pressed():
	Global.multipleOneCards = $VBox/OneCards/CheckBox.pressed

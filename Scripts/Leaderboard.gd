extends Node2D

func _ready():
	self.visible = false

func move(target):
	var move_tween = get_node("move_tween")
	move_tween.interpolate_property(self, "position", position, target, Global.animationSpeed, Tween.TRANS_QUINT, Tween.EASE_OUT)
	move_tween.start()


func open():
	move(Vector2(0, 0))
	

func close():
	move(Vector2(527, 0))


func _on_Button_pressed():
	if $Panel/Button.pressed:
		open()
	else:
		close()

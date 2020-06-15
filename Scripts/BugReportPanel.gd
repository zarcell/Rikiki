extends Node2D

func _ready():
	self.visible = true

func move(target):
	var move_tween = get_node("move_tween")
	move_tween.interpolate_property(self, "position", position, target, Global.animationSpeed, Tween.TRANS_QUINT, Tween.EASE_OUT)
	move_tween.start()

func up():
	move(Vector2(0, -300))
	$Timer.start(10)


func _on_Close_pressed():
	move(Vector2(0, 0))


func _on_Timer_timeout():
	move(Vector2(0, 0))

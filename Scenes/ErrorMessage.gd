extends Node2D

var startingPoint = Vector2(0, 1160)


func start():
	move(Vector2(0, 760))
	$Timer.start(2)


func setText(text : String):
	$Label.text = text


func goBack():
	move(startingPoint)


func move(target):
	var move_tween = $move_tween
	move_tween.interpolate_property(self, "position", position, target, Global.animationSpeed, Tween.TRANS_QUINT, Tween.EASE_OUT)
	move_tween.start()


func _on_Timer_timeout():
	goBack()

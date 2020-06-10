extends Node2D

func _ready():
	self.visible = true

func move(target):
	var move_tween = get_node("move_tween")
	move_tween.interpolate_property(self, "position", position, target, Global.animationSpeed, Tween.TRANS_QUINT, Tween.EASE_OUT)
	move_tween.start()


func _on_RichTextLabel_meta_clicked(meta):
	print(meta)
	OS.shell_open(meta)

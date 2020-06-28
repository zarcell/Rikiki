extends LineEdit

var point = 0

func _is_pos_in(checkpos:Vector2):
	var gr = get_global_rect()
	return checkpos.x >= gr.position.x and checkpos.y >= gr.position.y and checkpos.x < gr.end.x and checkpos.y < gr.end.y

func _input(event):
	if event is InputEventMouseButton and not _is_pos_in(event.position):
		release_focus()

func _on_Player_focus_exited():
	text = text.strip_edges()

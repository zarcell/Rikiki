extends Button

func _pressed():
	if Global.numberOfPlayers < 12:
		Global.numberOfPlayers += 1
	get_parent().get_node("Number").text = str(Global.numberOfPlayers)

extends Node2D

var players = []
var raising = true
var gamePhase = false
var currentPlayer = null

#SAVES
var save_raising
var save_rounds_node_text
var save_vsep_visible
var save_round_visible
var save_currentPlayer
var save_points = []

onready var rounds_node = $GamesPhase/GamePhaseMenu/HBox/Rounds

func _ready():
	resetGame()

func resetGame():
	raising = true
	$GamesPhase/GamePhaseMenu/HBox/Rounds.text = "1"
	$GamesPhase/Continue/VSeparator.visible = true
	$GamesPhase/Continue/Round.visible = true

func add_players():
	var players_node = $Phase2/Marg/ScrollContainer/Players
	var player_ins = preload("res://Scenes/player.tscn")
	
	var i = 0
	if players.size() < Global.numberOfPlayers:
		i = Global.numberOfPlayers - players.size()
		for _n in range(i):
			var instance = player_ins.instance()
			players_node.add_child(instance)
			players.append(instance)
	elif players.size() > Global.numberOfPlayers:
		i = players.size() - Global.numberOfPlayers
		for _n in range(i):
			players[-1].queue_free()
			players.pop_back()
	
	if players.size() > 5:
		var HSep_ins = preload("res://Scenes/HSep.tscn")
		for child in players_node.get_children():
			if child is HSeparator:
				child.queue_free()
		players_node.add_child(HSep_ins.instance())


func add_players_with_points():
	var players_points_node = $GamesPhase/GamePhaseMenu/ScrollC/Players
	var player_ins = preload("res://Scenes/playerPoints.tscn")
	
	#delete all children if exists
	for child in players_points_node.get_children():
		child.queue_free()
	
	var temp = []
	for n in range(Global.numberOfPlayers):
		var instance = player_ins.instance()
		instance.setText(players[n].text)
		instance.setPoint(0)
		players_points_node.add_child(instance)
		temp.append(instance)
	
	players = temp
	currentPlayer = 0
	players[currentPlayer].change_color(Global.lime)


func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST and gamePhase:
		$Panel.visible = true


func _on_Start_pressed():
	get_node("Start").move(Vector2(-576, 0))
	$Phase1/Phase1Menu/HBox/Number.text = str(Global.numberOfPlayers)
	$Phase1/Phase1Menu/HBox2/NumberOfLaps.text = str(Global.maximumLaps)
	get_node("Phase1").move(Vector2(0, 0))


func _on_Start_Back_pressed():
	get_node("Start").move(Vector2(0, 0))
	get_node("Phase1").move(Vector2(576, 0))


func _on_Phase1_Next_pressed():
	$Phase2/Marg/ScrollContainer.scroll_vertical_enabled = Global.numberOfPlayers > 5
	
	add_players()
	
	get_parent().get_node("TitleNode").move(Vector2(288, -300))
	get_node("Phase1").move(Vector2(-576, 0))
	get_node("Phase2").move(Vector2(0, 0))


func _on_Phase2_Back_pressed():
	get_parent().get_node("TitleNode").move(Vector2(288, 300))
	get_node("Phase1").move(Vector2(0, 0))
	get_node("Phase2").move(Vector2(576, 0))


func _on_How_to_play_pressed():
	get_node("Start").move(Vector2(-576, 0))
	get_parent().get_node("TitleNode").move(Vector2(288, 100))
	get_node("HowToPlay").move(Vector2(0, 0))


func _on_How_to_play_Back_pressed():
	get_node("Start").move(Vector2(0, 0))
	get_parent().get_node("TitleNode").move(Vector2(288, 300))
	get_node("HowToPlay").move(Vector2(576, 0))


#GAME BEGINS READY
func _on_Phase2_Next_pressed():
	$GamesPhase/GamePhaseMenu/ScrollC.scroll_vertical_enabled = Global.numberOfPlayers > 6
	
	for child in $Phase2/Marg/ScrollContainer/Players.get_children():
		if child is LineEdit:
			if child.text == "":
				#TODO uresnev hibapanel
				return
	add_players_with_points()
	resetGame()
	gamePhase = true
	
	get_node("Phase2").move(Vector2(-576, 0))
	get_node("GamesPhase").move(Vector2(0, 0))


func _on_GamePhase_Round_pressed():
	
	##############################################
	#saving current values
	save_raising = raising
	save_rounds_node_text = rounds_node.text
	save_vsep_visible = $GamesPhase/Continue/VSeparator.visible
	save_round_visible = $GamesPhase/Continue/Round.visible
	save_currentPlayer = currentPlayer
	save_points = []
	for child in players:
		save_points.append(child.getPoint())
	#show undo button if hidden
	if $GamesPhase/Undo.visible == false:
		$GamesPhase/Undo.visible = true
	##############################################
	
	if raising:
		rounds_node.text = str(int(rounds_node.text) + 1)
		if int(rounds_node.text) >= Global.maximumLaps:
			raising = false
	else:
		rounds_node.text = str(int(rounds_node.text) -1)
		if int(rounds_node.text) <= 0:
			#jatek vege
			$GamesPhase/Continue/VSeparator.visible = false
			$GamesPhase/Continue/Round.visible = false
	
	#calculating new points
	for child in players:
		child.calcPoints()
	
	#change color of the player names
	players[currentPlayer].change_color(Global.dark_gray)
	currentPlayer += 1
	if currentPlayer >= players.size():
		currentPlayer = 0
	players[currentPlayer].change_color(Global.lime)
	

func _on_GamePhase_Reset_pressed():
	$ResetPanel.visible = true


func _on_MaxLap_Minus_pressed():
	if Global.maximumLaps > 3:
		Global.maximumLaps -= 1
	$Phase1/Phase1Menu/HBox2/NumberOfLaps.text = str(Global.maximumLaps)


func _on_MaxLaps_Plus_pressed():
	if Global.maximumLaps < 12:
		Global.maximumLaps += 1
	$Phase1/Phase1Menu/HBox2/NumberOfLaps.text = str(Global.maximumLaps)


func _on_Panel_no_pressed():
	$Panel.visible = false


func _on_Panel_yes_pressed():
	get_tree().reload_current_scene()


func _on_ResetPanel_yes_pressed():
	$ResetPanel.visible = false
	$GamesPhase/Undo.visible = false
	resetGame()
	
	var list = $GamesPhase/GamePhaseMenu/ScrollC/Players.get_children()
	
	for child in list:
		child.reset()


func _on_ResetPanel_no_pressed():
	$ResetPanel.visible = false


func _on_QuitButton_pressed():
	$Panel.visible = true


#UNDO
func _on_GamePhase_Undo_pressed():
	$GamesPhase/Undo.visible = false
	
	raising = save_raising
	rounds_node.text = save_rounds_node_text
	$GamesPhase/Continue/VSeparator.visible = save_vsep_visible
	$GamesPhase/Continue/Round.visible = save_round_visible
	players[currentPlayer].change_color(Global.dark_gray)
	currentPlayer = save_currentPlayer
	players[currentPlayer].change_color(Global.lime)
	for i in range(save_points.size()):
		players[i].reset()
		players[i].setPoint(save_points[i])

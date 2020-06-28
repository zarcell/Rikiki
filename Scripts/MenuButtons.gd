extends Node2D

var players = []
var raising = true
var gamePhase = false
var currentPlayer = null
var lastRound = false

#SAVES
var save_raising
var save_lastRound
var save_rounds_node_text
var save_vsep_visible
var save_round_visible
var save_currentPlayer
var save_points = []

onready var rounds_node = $GamesPhase/GamePhaseMenu/HBox/Rounds

func _ready():
	resetGame()

func resetGame():
	raising = !Global.startWithMax
	lastRound = false
	$GamesPhase/GamePhaseMenu/HBox/Rounds.text = "1" if raising else str(Global.maximumLaps)
	$GamesPhase/Continue/VSeparator.visible = true
	$GamesPhase/Continue/Round.visible = true
	$GamesPhase/Undo.visible = false

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
				players_node.remove_child(child)
				child.queue_free()
		players_node.add_child(HSep_ins.instance())


func add_players_with_points():
	var players_points_node = $GamesPhase/GamePhaseMenu/ScrollC/Players
	var player_ins = preload("res://Scenes/playerPoints.tscn")
	
	#delete all children if exists
	for child in players_points_node.get_children():
		players_points_node.remove_child(child)
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
	
	# Leaderboard
	updateLeaderboard()
	print("when adding players")


func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST and gamePhase:
		$Panel.visible = true


# Panel movings
func _on_Start_pressed():
	$AntiClick.start()
	
	get_parent().get_node("TitleNode").move(Vector2(288, 100))
	get_node("Start").move(Vector2(-576, 0))
	get_node("Phase1").move(Vector2(0, 0))


func _on_Start_Back_pressed():
	$AntiClick.start()
	
	get_parent().get_node("TitleNode").move(Vector2(288, 300))
	get_node("Start").move(Vector2(0, 0))
	get_node("Phase1").move(Vector2(576, 0))


func _on_Phase1_Next_pressed():
	$AntiClick.start()
	
	$Phase2/Marg/ScrollContainer.scroll_vertical_enabled = Global.numberOfPlayers > 5
	
	add_players()
	
	get_parent().get_node("TitleNode").move(Vector2(288, -300))
	get_node("Phase1").move(Vector2(-576, 0))
	get_node("Phase2").move(Vector2(0, 0))


func _on_Phase2_Back_pressed():
	$AntiClick.start()
	
	get_parent().get_node("TitleNode").move(Vector2(288, 100))
	get_node("Phase1").move(Vector2(0, 0))
	get_node("Phase2").move(Vector2(576, 0))


func _on_How_to_play_pressed():
	$AntiClick.start()
	
	get_node("Start").move(Vector2(-576, 0))
	get_parent().get_node("TitleNode").move(Vector2(288, 100))
	get_node("HowToPlay").move(Vector2(0, 0))


func _on_How_to_play_Back_pressed():
	$AntiClick.start()
	
	get_node("Start").move(Vector2(0, 0))
	get_parent().get_node("TitleNode").move(Vector2(288, 300))
	get_node("HowToPlay").move(Vector2(576, 0))


#GAME BEGINS READY
func _on_Phase2_Next_pressed():
	# checking blank names
	for child in $Phase2/Marg/ScrollContainer/Players.get_children():
		if child is LineEdit:
			if child.text.strip_edges() == "":
				$ErrorMessage.setText("Incorrect name!")
				$ErrorMessage.start()
				return
	
	$GamesPhase/GamePhaseMenu/ScrollC.scroll_vertical_enabled = Global.numberOfPlayers > 6
	$Leaderboard.visible = true
	
	add_players_with_points()
	resetGame()
	gamePhase = true
	
	get_node("Phase2").move(Vector2(-576, 0))
	get_node("GamesPhase").move(Vector2(0, 0))


# Making a round
func _on_GamePhase_Round_pressed():
	var sum = 0
	for child in players:
		sum += child.getGNum()
	if sum != int(rounds_node.text):
		var temp = int(rounds_node.text)
		if sum < temp:
			$ErrorMessage.setText("Someone missed a point!")
		else:
			$ErrorMessage.setText("Someone got too many points!")
		$ErrorMessage.start()
		return
	##############################################
	#saving current values
	save_raising = raising
	save_lastRound = lastRound
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
	
	if !lastRound:
		#kor szamolas
		var fastMode = 1 if Global.fastGame else 0
		
			#ha emelkedik
		if raising:
			rounds_node.text = str(int(rounds_node.text) + 1 + fastMode)
			if int(rounds_node.text) >= Global.maximumLaps:
				raising = false
				if Global.startWithMax or (!Global.startWithMax and !Global.extraReverseRound):
					#utso kor
					lastRound = true
			#ha csokken
		else:
			rounds_node.text = str(int(rounds_node.text) - 1 - fastMode)
			if int(rounds_node.text) <= 1:
				raising = true
				if (!Global.startWithMax or (Global.startWithMax and !Global.extraReverseRound)):
					#utso kor
					lastRound = true
	else:
		$GamesPhase/Continue/VSeparator.visible = false
		$GamesPhase/Continue/Round.visible = false
		rounds_node.text = "-"
	
	#calculating new points
	for child in players:
		child.calcPoints()
		
	#leaderboard points update
	updateLeaderboard()
	print("from round pressed")
	
	#change color of the player names
	players[currentPlayer].change_color(Global.dark_gray)
	currentPlayer += 1
	if currentPlayer >= players.size():
		currentPlayer = 0
	players[currentPlayer].change_color(Global.lime)
	

func updateLeaderboard():
	var lb_players_node = $Leaderboard/PanelC/VBox/Players
	var lb_player_ins = preload("res://Scenes/playerScores.tscn")
	var lb_players = []
	
	for child in lb_players_node.get_children():
		lb_players_node.remove_child(child)
		child.queue_free()
		
	print(players.size())
	for p in players:
		var ins = lb_player_ins.instance()
		ins.setName(p.getText())
		ins.setPoint(p.getPoint())
		lb_players.append(ins)
	
	lb_players.sort_custom(self, "comp")
	
	for p in lb_players:
		lb_players_node.add_child(p)
	
func comp(a, b):
	return a.getPoint() > b.getPoint()
	

func _on_GamePhase_Reset_pressed():
	$ResetPanel.visible = true


func _on_MaxLap_Minus_pressed():
	if Global.maximumLaps > 3:
		Global.maximumLaps -= 1
		if Global.fastGame:
			Global.maximumLaps -= 1
	$Phase1/Phase1Menu/HBox2/NumberOfLaps.text = str(Global.maximumLaps)


func _on_MaxLaps_Plus_pressed():
	if Global.maximumLaps < 15:
		Global.maximumLaps += 1
		if Global.fastGame:
			Global.maximumLaps += 1
	$Phase1/Phase1Menu/HBox2/NumberOfLaps.text = str(Global.maximumLaps)


func _on_Panel_no_pressed():
	$Panel.visible = false


func _on_Panel_yes_pressed():
	get_tree().reload_current_scene()


func _on_ResetPanel_yes_pressed():
	$ResetPanel.visible = false
	
	var list = $GamesPhase/GamePhaseMenu/ScrollC/Players.get_children()
	
	for child in list:
		child.reset()
		
	updateLeaderboard()
	
	resetGame()


func _on_ResetPanel_no_pressed():
	$ResetPanel.visible = false


func _on_QuitButton_pressed():
	$Panel.visible = true


#UNDO
func _on_GamePhase_Undo_pressed():
	$GamesPhase/Undo.visible = false
	
	raising = save_raising
	lastRound = save_lastRound
	rounds_node.text = save_rounds_node_text
	$GamesPhase/Continue/VSeparator.visible = save_vsep_visible
	$GamesPhase/Continue/Round.visible = save_round_visible
	players[currentPlayer].change_color(Global.dark_gray)
	currentPlayer = save_currentPlayer
	players[currentPlayer].change_color(Global.lime)
	for i in range(save_points.size()):
		players[i].reset()
		players[i].setPoint(save_points[i])
		
	# update leaderboard
	updateLeaderboard()
	print("from undo")


func _on_Settings_pressed():
	$AntiClick.start()
	
	get_parent().get_node("TitleNode").move(Vector2(288, 100))
	$Start.move(Vector2(-576, 0))
	$Settings.move(Vector2(0, 0))


func _on_Settings_Back_pressed():
	$AntiClick.start()
	
	get_parent().get_node("TitleNode").move(Vector2(288, 300))
	$Start.move(Vector2(0, 0))
	$Settings.move(Vector2(576, 0))


func _on_Bug_pressed():
	$BugReportPanel.up()


func _on_Donate_pressed():
	var URL = "https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=EYEA52E2HCXAG&source=url"
	OS.shell_open(URL)

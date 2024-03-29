extends VBoxContainer

var active = true

func _ready():
	$HBox/SNum.text = "0"
	$HBox/GNum.text = "0"

func toggle():
	if active:
		change_color(Global.light_gray)
		$HBox.visible = false
	else:
		change_color(Global.dark_gray)
		$HBox.visible = true
		
	active = !active

func setText(text):
	$Infos/Name.text = text

func getText():
	return $Infos/Name.text

func setPoint(p):
	$Infos/Point.text = str(p)
	
func getPoint():
	return int($Infos/Point.text)
	
func getGNum():
	return int($HBox/GNum.text)

func change_color(color):
	$Infos/Name.add_color_override("font_color", Color(color))

func calcPoints():
	var snum = int($HBox/SNum.text)
	var gnum = int($HBox/GNum.text)
	var plusPoints = 0
	
	if snum == gnum:
		if gnum == 0 and Global.nullBidWorthHalf:
			plusPoints = int(Global.hittingBidExtra / 2)
		else:
			plusPoints = Global.hittingBidExtra + (gnum * Global.trickWinExtra)
	else:
		if Global.pointsWhenMissingBid:
			plusPoints = Global.trickWinExtra * gnum
		else:
			plusPoints = abs(snum-gnum) * -Global.missingBidMinus
	
	#change values
	var currentPoints = int($Infos/Point.text)
	$Infos/Point.text = str(currentPoints + plusPoints)
	
	#reset got and said numbers
	$HBox/SNum.text = "0"
	$HBox/GNum.text = "0"


func reset():
	$Infos/Point.text = "0"
	$HBox/SNum.text = "0"
	$HBox/GNum.text = "0"


func _on_Said_Minus_pressed():
	var snum = int($HBox/SNum.text)
	if snum > 0:
		snum -= 1
		$HBox/SNum.text = str(snum)


func _on_Said_Plus_pressed():
	var snum = int($HBox/SNum.text)
	if snum < 15:
		snum += 1
		$HBox/SNum.text = str(snum)


func _on_Got_Minus_pressed():
	var gnum = int($HBox/GNum.text)
	if gnum > 0:
		gnum -= 1
		$HBox/GNum.text = str(gnum)


func _on_Got_Plus_pressed():
	var gnum = int($HBox/GNum.text)
	if gnum < 15:
		gnum += 1
		$HBox/GNum.text = str(gnum)


func _on_Name_pressed():
	Global.chosenPlayer = self
	var playerPanel = get_tree().get_root().find_node("PlayerPanel", true, false)
	playerPanel.open()

extends Node2D


func _ready():
	self.visible = true

func move(target):
	# Fix the numbers by globals
	$VBox/VBox/HittingBid/Number.text = str(Global.hittingBidExtra)
	$VBox/VBox2/WinTricks/Number.text = str(Global.trickWinExtra)
	$VBox/MissingBid/CheckBox.pressed = Global.pointsWhenMissingBid
	$VBox/VBox3.visible = !Global.pointsWhenMissingBid
	$VBox/NullBid/CheckBox.pressed = Global.nullBidWorthHalf
	
	var move_tween = get_node("move_tween")
	move_tween.interpolate_property(self, "position", position, target, Global.animationSpeed, Tween.TRANS_QUINT, Tween.EASE_OUT)
	move_tween.start()


func _on_HittingBid_Minus_pressed():
	var number = int($VBox/VBox/HittingBid/Number.text)
	if number > 2:
		number -= 2
		Global.hittingBidExtra = number
		$VBox/VBox/HittingBid/Number.text = str(number)


func _on_HittingBid_Plus_pressed():
	var number = int($VBox/VBox/HittingBid/Number.text)
	if number < 10:
		number += 2
		Global.hittingBidExtra = number
		$VBox/VBox/HittingBid/Number.text = str(number)


func _on_WinTricks_Minus_pressed():
	var number = int($VBox/VBox2/WinTricks/Number.text)
	if number > 0:
		number -= 1
		Global.trickWinExtra = number
		$VBox/VBox2/WinTricks/Number.text = str(number)


func _on_WinTricks_Plus_pressed():
	var number = int($VBox/VBox2/WinTricks/Number.text)
	if number < 5:
		number += 1
		Global.trickWinExtra = number
		$VBox/VBox2/WinTricks/Number.text = str(number)


func _on_MissingBid_CheckBox_pressed():
	Global.pointsWhenMissingBid = $VBox/MissingBid/CheckBox.pressed
	$VBox/VBox3.visible = !Global.pointsWhenMissingBid


func _on_MissingBid_Minus_pressed():
	var number = int($VBox/VBox3/MissingMinus/Number.text)
	if number > 0:
		number -= 1
		Global.missingBidMinus = number
		$VBox/VBox3/MissingMinus/Number.text = str(number)


func _on_MissingBid_Plus_pressed():
	var number = int($VBox/VBox3/MissingMinus/Number.text)
	if number < 3:
		number += 1
		Global.missingBidMinus = number
		$VBox/VBox3/MissingMinus/Number.text = str(number)


func _on_NullBid_CheckBox_pressed():
	Global.nullBidWorthHalf = $VBox/NullBid/CheckBox.pressed

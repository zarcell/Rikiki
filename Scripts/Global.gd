extends Node2D

var numberOfPlayers = 3
var chosenPlayer = null
var maximumLaps = 7

# SETTINGS
var fastGame = false
var startWithMax = false
var extraReverseRound = false

# POINT CALC
var hittingBidExtra = 10
var trickWinExtra = 1
var pointsWhenMissingBid = true
var missingBidMinus = 2
var nullBidWorthHalf = false

var animationSpeed = 0.5

#paletta
var light_gray = "#b5b5b5"
var gray = "#818181"
var dark_gray = "#232323"
var orange = "#FF4500"
var crimson = "#DC143C"
var blue = "#0000CD"
var lime = "#2aad2a"

func save():
	var save_dict = {
		"fast_game" : fastGame,
		"start_with_max" : startWithMax,
		"extra_reverse_round" : extraReverseRound,
		"hitting_bid_extra" : hittingBidExtra,
		"trick_win_extra" : trickWinExtra,
		"points_when_missing_bid" : pointsWhenMissingBid,
		"missing_bid_minus" : missingBidMinus,
		"null_bid_worth_half": nullBidWorthHalf
	}
	
	return save_dict

func save_data():
	var save_file = File.new()
	save_file.open("user://settings.save", File.WRITE)
	save_file.store_line(to_json(save()))
	save_file.close()
	
func load_data():
	var save_file = File.new()
	if not save_file.file_exists("user://settings.save"):
		return # Error, no save_file
	
	save_file.open("user://settings.save", File.READ)
	var save_dict = parse_json(save_file.get_line())
	
	fastGame = save_dict["fast_game"]
	startWithMax = save_dict["start_with_max"]
	extraReverseRound = save_dict["extra_reverse_round"]
	
	hittingBidExtra = save_dict["hitting_bid_extra"]
	trickWinExtra = save_dict["trick_win_extra"]
	pointsWhenMissingBid = save_dict["points_when_missing_bid"]
	missingBidMinus = save_dict["missing_bid_minus"]
	nullBidWorthHalf = save_dict["null_bid_worth_half"]
	
	save_file.close()

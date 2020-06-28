extends HBoxContainer


func setName(name):
	$Name.text = str(name)


func setPoint(point):
	$Score.text = str(point)


func getPoint():
	return int($Score.text)

extends HBoxContainer

export var datetime := "XXX"
export var score := 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(_delta):
	$DatetimeLabel.text = datetime
	$ScoreLabel.text = str(score).pad_zeros(5)

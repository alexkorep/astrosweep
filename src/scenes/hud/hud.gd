extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(_delta):
	get_node("%ScoreLabel").text = str(GameState.score).pad_zeros(5)
	get_node("%Hearts").count = GameState.lives

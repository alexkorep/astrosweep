extends Control

var blink_timer = 0.5
var is_visible = true

func _ready():
	# Start the timer for blinking text
	set_process(true)
	_update_scores()

func _process(delta):
	blink_timer -= delta
	if blink_timer <= 0:
		blink_timer = 0.5
		is_visible = !is_visible
		get_node("%PressAnyKeySprite").visible = is_visible

func _input(event):
	if ((event is InputEventKey and event.pressed) 
	or (event is InputEventMouseButton and event.pressed)):
		get_tree().change_scene("res://scenes/main_screen/main_screen.tscn")

func _update_scores():
	var score_list = get_node("%ScoreList")
	var i = 0
	var scores = GameState.high_scores
	for score_row in score_list.get_children():
		if i < len(scores):
			var score = scores[i]
			score_row.initials = score.initials
			score_row.score = score.score
		else:
			score_row.initials = "AAA"
			score_row.score = 0
		i += 1

extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	var windowHeight = OS.get_real_window_size().y
	var safeAreaTop = OS.get_window_safe_area().position.y
	var normalizedPosition = safeAreaTop / windowHeight * 720
	rect_position.y = normalizedPosition
	
func _process(_delta):
	get_node("%ScoreLabel").text = str(GameState.score).pad_zeros(5)
	get_node("%Hearts").count = GameState.lives
	get_node("%WaveLabel").text = ("Wave " + str(GameState.wave) + 
		" [" + str(GameState.asteroids_killed) + 
		"/" + str(GameState.get_asteroids_in_current_wave()) +"]")

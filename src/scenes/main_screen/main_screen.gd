extends Control

var is_paused = false

var progress = 0.0


# astroclicks persecond
var speed = 0.01 

var current_formation = null

onready var Player = $Player
onready var banner = get_node("%Banner")

enum WaveState {
	# Display level/attempt screen
	WAVE_INTRO,
	# Display level cleared/wave failed screen
	WAVE_RESULTS
}

var formation_scenes = [
	preload("res://scenes/asteroids/asteroids.tscn"),
]

func _ready():
	GameState.new_game()
	GameState.set_wave(0)

# Formation events
#
func _on_enemy_died():
	# TODO increase score based on the enemy hp
	GameState.increment_score(1)

func _on_wave_finished():
	# TODo remember and show win/loose
	banner.text = "Wave Finished"
	banner.extra = WaveState.WAVE_RESULTS
	banner.start()
	
func _process(delta):
	if current_formation != null:
		current_formation.set_player_pos(Player.position)

func _on_Player_ship_exploded():
	if GameState.high_score_reached():
		get_tree().change_scene("res://scenes/high_score/enter_your_initials.tscn")
	else:
		get_tree().change_scene("res://scenes/high_score/high_score.tscn")

func _on_Player_player_ready():
	next_wave()

func next_wave():
	GameState.next_wave()
	banner.text = "Wave " + str(GameState.wave)
	banner.start()
	banner.extra = WaveState.WAVE_INTRO

func start_wave():
	if current_formation != null:
		current_formation.queue_free()
	var formation_num = randi() % formation_scenes.size()
	current_formation = formation_scenes[formation_num].instance()
	current_formation.connect("finished", self, "_on_wave_finished")
	current_formation.connect("enemy_died", self, "_on_enemy_died")
	current_formation.set_wave(GameState.wave)
	get_node("%EnemyFormations").add_child(current_formation)


func _on_Banner_finished():
	if banner.extra == WaveState.WAVE_INTRO:
		start_wave()
	else:
		# TODO depending on wave win/loose either 
		# next wave, or the same
		next_wave()

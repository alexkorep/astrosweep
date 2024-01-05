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
	GameState.asteroid_killed()

func _on_wave_finished():
	if GameState.is_current_wave_cleared():
		banner.text = "Clear!"
	else:
		banner.text = "Failed!"
		Player.explode()
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
	GameState.next_wave()
	show_wave_banner()

func show_wave_banner():
	banner.text = "Wave " + str(GameState.wave) + "\nAttempt " + str(GameState.wave_attempt)
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
		if GameState.is_current_wave_cleared():
			GameState.next_wave()
		else:
			GameState.next_attempt()
		show_wave_banner()

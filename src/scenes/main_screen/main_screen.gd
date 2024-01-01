extends Control

var is_paused = false
var time = 0

var progress = 0.0


# astroclicks persecond
var speed = 0.01 

var current_wave = 0
var current_formation = null

onready var Player = $Player
onready var WaveLabel = $WaveLabel

var formation_scenes = [
	preload("res://scenes/asteroids/asteroids.tscn"),
]

func _ready():
	$Background.get_material().set_shader_param("speed_scale", 0.1)
	GameState.new_game()
	current_wave = 0
	update_wave_label()

func update_wave_label():
	WaveLabel.text = "Wave " + str(current_wave + 1)

# Formation events
#
func _on_enemy_died():
	# TODO increase score based on the enemy hp
	GameState.increment_score(1)

func _on_wave_finished():
	current_wave += 1
	next_wave()
	
func _process(delta):
	if is_paused == false:
		$Background.get_material().set_shader_param("time", time)
		time += delta
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
	if current_formation != null:
		current_formation.queue_free()
	var formation_num = randi() % formation_scenes.size()
	current_formation = formation_scenes[formation_num].instance()
	current_formation.connect("finished", self, "_on_wave_finished")
	current_formation.connect("enemy_died", self, "_on_enemy_died")
	current_formation.set_wave(current_wave)
	get_node("%EnemyFormations").add_child(current_formation)
	update_wave_label()

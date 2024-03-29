extends Control

var asteroid_count := 20
var asteroid_hp := 1

signal finished
signal enemy_died

var asteroid_instance := preload("res://scenes/asteroids/asteroid.tscn")
var is_finished = false

func _ready():
	for i in range(asteroid_count):
		var asteroid := asteroid_instance.instance()
		asteroid.position = Vector2(
			rand_range(rect_position.x, rect_position.x + rect_size.x), 
			rand_range(rect_position.y - rect_size.y, rect_position.y)
			)
		asteroid.speed = rand_range(50, 100)
		# subscribe to asteroid_killed
		# warning-ignore:return_value_discarded
		asteroid.connect("asteroid_killed", self, "on_asteroid_killed")
		asteroid.hp = asteroid_hp
		if i == asteroid_count - 1:
			# last asteroid is a powerup
			asteroid.powerup_id = GameState.get_random_powerup()
			print(asteroid.powerup_id)
		add_child(asteroid)

func _process(_delta):
	if get_child_count() == 0 and not is_finished:
		emit_signal("finished")
		is_finished = true

func set_player_pos(_pos):
	# We don't care, we are stones
	pass

func on_asteroid_killed():
	emit_signal("enemy_died")

func set_wave(idx):
	asteroid_count = GameState.get_asteroids_per_wave(idx)
	asteroid_hp = GameState.get_asteroid_hp(idx)

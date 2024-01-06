extends Node

var funds := 0
var planet_id: String = ""
var current_ship_id = 'xq5'
var owned_ships = ['xq5']
var score = 0
# {score: 0, initials: "AAA"}
var high_scores = []

var lives = 3
var wave = 1
# Number of asteroids killed on the current wave,
# needed to track if the wave is cleared or some asteroids have passed
var asteroids_killed = 0

# Number of times the player has attempts the current wave, 1-based
var wave_attempt = 0

var savegame_filename = "user://savegame.save"
var highscores_filename = "user://hiscores.save"

func _ready():
	load_high_scores()
	if load_game():
		print("Loaded game")
		return
	new_game()

func new_game():
	funds = 0
	score = 0
	lives = 3

# Save the state of the game
func save_game():
	var save_dict = {
			"funds": funds,
			"owned_ships": owned_ships,
			"current_ship_id": current_ship_id
	}
	var save_file = File.new()
	save_file.open(savegame_filename, File.WRITE)
	save_file.store_var(save_dict)
	save_file.close()

# Load the state of the game
func load_game():
	var save_file = File.new()
	if not save_file.file_exists(savegame_filename):
		return false

	save_file.open(savegame_filename, File.READ)
	var save_dict = save_file.get_var()

	funds = save_dict["funds"]
	planet_id = save_dict["planet_id"]
	owned_ships = save_dict["owned_ships"] if "owned_ships" in save_dict else ['xq5']
	current_ship_id = save_dict["current_ship_id"] if "current_ship_id" in save_dict  else 'xq5'

	save_file.close()

	if planet_id == "":
		return false
	return true

func save_high_scores():
	var save_dict = {
		"high_scores": high_scores
	}
	var save_file = File.new()
	save_file.open(highscores_filename, File.WRITE)
	save_file.store_var(save_dict)
	save_file.close()

func load_high_scores():
	var save_file = File.new()
	if not save_file.file_exists(highscores_filename):
		return false

	save_file.open(highscores_filename, File.READ)
	var save_dict = save_file.get_var()
	high_scores = save_dict["high_scores"] if "high_scores" in save_dict else []
	save_file.close()
	return true

func can_buy_ship(ship_id):
	if is_ship_owned(ship_id):
		return false
	
	var ship_model = ShipModels.get_ship_by_id(ship_id)
	var price = ship_model["price"]
	if price > GameState.funds:
		return false
	return true

func buy_ship(ship_id):
	if not can_buy_ship(ship_id):
		return false
	var ship_model = ShipModels.get_ship_by_id(ship_id)
	var price = ship_model["price"]
	GameState.funds -= price
	current_ship_id = ship_id
	owned_ships.append(ship_id)
	save_game()
	return true

func is_ship_owned(ship_id):
	return ship_id in owned_ships

func set_selected_ship_id(id):
	current_ship_id = id
	save_game()


func increment_score(amount):
	score += amount

func high_score_reached():
	if len(high_scores) < 10:
		return true
	for i in range(10):
		if score > high_scores[i].score:
			return true
	return false

func add_high_score(initials):
	var new_score = {
		"score": score,
		"initials": initials
	}
	high_scores.append(new_score)
	high_scores.sort_custom(self, "sort_scores")
	save_high_scores()

func sort_scores(a, b):
	return a.score > b.score  

func increment_lives():
	if lives < 3:
		lives += 1

func decrement_lives():
	lives -= 1


var powerup_drop_chance_per_wave = {
	"heart": 1,
	"rps": 2,
}

func get_random_powerup() -> String:
	var total = 0
	for value in powerup_drop_chance_per_wave.values():
		total += value

	var rand = randi() % total
	var cumulative = 0

	for powerup in powerup_drop_chance_per_wave.keys():
		cumulative += powerup_drop_chance_per_wave[powerup]
		if rand < cumulative:
			return powerup
		# Should never happen
	assert(false)
	return ""
	
func set_wave(value):
	wave = value

func next_wave():
	set_wave(wave + 1)
	asteroids_killed = 0
	wave_attempt = 1

func next_attempt():
	wave_attempt += 1
	asteroids_killed = 0

func asteroid_killed():
	increment_score(1)
	asteroids_killed += 1

func get_asteroids_per_wave(idx):
	return idx * 2

func get_asteroid_hp(idx):
	return idx

func get_asteroids_in_current_wave():
	return get_asteroids_per_wave(wave)

func is_current_wave_cleared():
	return asteroids_killed >= get_asteroids_per_wave(wave)

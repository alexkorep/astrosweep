extends Node

var WIN_FUNDS = 10_000_000

var funds := 0
var planet_id: String = ""
var current_ship_id = 'xq5'
var owned_ships = ['xq5']

var price_vadiance = 0.05

# TODO add an option to choose the seed or change it
# Make new seed for a new game
var map_generation_seed = 283777479

# array of prices for each good
var prices = []
# Stock on the planet and player
var planet_quantity = []
var player_quantity = []

var savegame_filename = "user://savegame.save"

func _ready():
	if load_game():
		print("Loaded game")
		return
	new_game()

func new_game():
	print("New game")
	funds = 2000
	prices = []
	planet_quantity = []
	player_quantity = []		

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
	print("owned_ships", owned_ships)
	return true

func is_ship_owned(ship_id):
	return ship_id in owned_ships

func set_selected_ship_id(id):
	current_ship_id = id
	save_game()

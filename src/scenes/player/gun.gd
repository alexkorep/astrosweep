extends Node2D

var bullet_scene = preload("res://scenes/player/player_bullet.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func start():
	var ship_id = GameState.current_ship_id
	var ship = ShipModels.get_ship_by_id(ship_id)
	get_node("%ShootTimer").wait_time = 1.0/ship["gun_rps"]
	get_node("%ShootTimer").start()
	
func stop():
	get_node("%ShootTimer").stop()

func _on_ShootTimer_timeout():
	var b = bullet_scene.instance()
	get_tree().root.add_child(b)
	b.start(global_position)

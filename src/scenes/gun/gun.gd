extends Node2D

export var gun_id = 'basic' setget set_gun_id
var current_gun = null
var started = false

var gun_scenes = {
	'basic': preload("res://scenes/gun/gun_basic.tscn"),
}

# Called when the node enters the scene tree for the first time.
func _ready():
	set_gun_id(gun_id)
	
func set_gun_id(new_gun_id):
	gun_id = new_gun_id
	if current_gun != null:
		remove_child(current_gun)
	current_gun = gun_scenes[new_gun_id].instance()
	add_child(current_gun)
	if started:
		current_gun.start() 

func start():
	started = true
	current_gun.start()
	
func stop():
	started = false
	current_gun.stop()

func upgrade_gun_level():
	current_gun.upgrade_gun_level()
	

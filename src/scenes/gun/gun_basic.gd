extends Node2D

var bullet_scene = preload("res://scenes/gun/player_bullet.tscn")

var level = 1

"""
Parameters:
1. Number of guns
2. bullet speed
3. time between bullets (rps)
"""

func _ready():
	start()

func start():
	set_gun_level(level)
	get_node("%ShootTimer").start()

func stop():
	get_node("%ShootTimer").stop()

func shoot(pos, dir):
	var b = bullet_scene.instance()
	var root = get_tree().current_scene
	# TODO Do not reference the BulletsLayer node by name.
	# Add some kind of dependency injection or something.
	var target_node = root.get_node("BulletsLayer")
	target_node.add_child(b)
	b.speed = level * 100
	b.start(global_position + pos, dir)

func _on_ShootTimer_timeout():
	if level == 1:
		# Center, up
		shoot(Vector2.ZERO, Vector2(0, -1))
	elif level == 2:
		# Center left, senter right, up
		shoot(Vector2(-5, 0), Vector2(0, -1))
		shoot(Vector2(5, 0), Vector2(0, -1))
	elif level == 3:
		# Up, slightly left, slightly right
		shoot(Vector2.ZERO, Vector2(0, -1))
		shoot(Vector2(-5, 0), Vector2(-0.3, -1))
		shoot(Vector2(5, 0), Vector2(0.3, -1))
	elif level == 4:
		# Up, left, right
		shoot(Vector2.ZERO, Vector2(0, -1))
		shoot(Vector2(0, 0), Vector2(-1, 0))
		shoot(Vector2(0, 0), Vector2(1, 0))
	elif level == 5:
		# Two up, one left, one right
		shoot(Vector2(-5, 0), Vector2(0, -1))
		shoot(Vector2(5, 0), Vector2(0, -1))
		shoot(Vector2(0, 0), Vector2(-1, 0))
		shoot(Vector2(0, 0), Vector2(1, 0))
	elif level == 6:
		# Two up, one left, one right, one down
		shoot(Vector2(-5, 0), Vector2(0, -1))
		shoot(Vector2(5, 0), Vector2(0, -1))
		shoot(Vector2(0, 0), Vector2(-1, 0))
		shoot(Vector2(0, 0), Vector2(1, 0))
		shoot(Vector2(0, 0), Vector2(0, 1))

func set_gun_level(value):
	level = value
	var time = 1.0/level
	get_node("%ShootTimer").set_wait_time(time)

func upgrade_gun_level():
	if level < 6:
		set_gun_level(level + 1)

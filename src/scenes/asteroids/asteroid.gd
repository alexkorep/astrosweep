extends Area2D

signal asteroid_killed

onready var ExplosionParticles = $ExplosionParticles
onready var ExplosionTimer = $ExplosionTimer
onready var Sprites = $Sprites
onready var CollisionShape2D = $CollisionShape2D
onready var CPUParticles2D = $CPUParticles2D

var powerup_scene = preload("res://scenes/powerup/powerup.tscn")

export var speed := 50

export var hp = 1
var hp_adjusted = 0

var white_shader_material = preload("res://resources/white_sprite_shadermaterial.tres")

var hp_multiplier_per_sprite = [3, 2, 1, 2, 1, 1, 1]

func _ready():
	# Randomly select a sprite
	var sprite_index = randi() % Sprites.get_child_count()
	hp_adjusted = hp * hp_multiplier_per_sprite[sprite_index]
	var i = 0
	for sprite in Sprites.get_children():
		sprite.visible = i == sprite_index
		i += 1
	var sprite = Sprites.get_children()[sprite_index]
	# Set the collision shape to match the sprite
	var size = sprite.region_rect.size.x
	CollisionShape2D.shape = CircleShape2D.new()
	CollisionShape2D.shape.radius = size / 2
	print(CollisionShape2D.shape.radius)
	CPUParticles2D.emission_shape = CPUParticles2D.EMISSION_SHAPE_RECTANGLE
	CPUParticles2D.emission_rect_extents.x = size/2*0.8

func _process(delta):
	position.y += speed * delta

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func enemy_hit(damage):
	hp_adjusted -= damage
	if hp_adjusted <= 0:
		kill()
	else:
		play_hit_animation()

func play_hit_animation():
	var sprites = get_node("%Sprites")
	for sprite in sprites.get_children():
		sprite.material = white_shader_material
	get_node("%HitAnimationTimer").start()
	
func _on_HitAnimationTimer_timeout():
	var sprites = get_node("%Sprites")
	for sprite in sprites.get_children():
		sprite.material = null

func kill():	
	for sprite in Sprites.get_children():
		sprite.queue_free()
	CollisionShape2D.queue_free()
	ExplosionParticles.emitting = true
	ExplosionTimer.start()
	emit_signal("asteroid_killed")
	# TODO move to a separate function
	var powerup = GameState.drop_powerup()
	if powerup != null:
		drop_powerup(powerup)
	
func drop_powerup(powerup_id):
	var powerup = powerup_scene.instance()
	powerup.position = position
	powerup.powerup_id = powerup_id
	get_tree().root.add_child(powerup)

func _on_ExplosionTimer_timeout():
	queue_free()

func _on_Asteroid_body_entered(body):
	if body.has_method("damage"):
		# Damaging the player
		body.damage()

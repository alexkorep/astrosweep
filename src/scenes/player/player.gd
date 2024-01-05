extends KinematicBody2D

signal end_animation_finished
signal ship_exploded
signal player_ready

export var max_speed := 200.0
export var shield = 100.0

export var show_ship_trail := false setget set_show_ship_trail

onready var PlayerStateMachine = $PlayerStateMachine
onready var Explosion = $Explosion
onready var ExplosionParticles = $Explosion/ExplosionParticles
onready var Ship = $Ship
onready var ShipTrailParticles = $Ship/ShipTrailParticles
onready var ShipSprite = $Ship/ShipSprite

# Called when the node enters the scene tree for the first time.
func _ready():
	var ship_id = GameState.current_ship_id
	get_node("%ShipSprite").set_ship_id(ship_id)

func damage():
	PlayerStateMachine.state.damage()
	
func explode():
	# Called by the main_screen when the attempt failed
	damage()

func emit_ship_exploded():
	emit_signal("ship_exploded")

func end():
	PlayerStateMachine.transition_to("End")
	
func emit_end_animation_finished():
	emit_signal("end_animation_finished")
	
func emit_player_ready():
	emit_signal("player_ready")

func set_show_ship_trail(value):
	show_ship_trail = value
	if value:
		ShipTrailParticles.texture = ShipSprite.get_texture()
		ShipTrailParticles.emitting = true
	else:
		ShipTrailParticles.emitting = false
		
func powerup(powerup_id):
	PlayerStateMachine.state.powerup(powerup_id)

func increment_rps():
	# TODO work with ship id
	get_node("%Gun").increment_rps()

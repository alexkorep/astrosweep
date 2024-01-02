# Idle.gd
extends State

var timer = null

# Upon entering the state, we set the Player node's velocity to zero.
func enter(_msg := {}) -> void:
	owner.Ship.hide()
	owner.ExplosionParticles.emitting = true
	timer = owner.get_node("%ExplodeTimer")
	timer.start()
	
func exit() -> void:
	pass

func damage():
	pass

func powerup(_powerup_id):
	pass

func _on_ExplodeTimer_timeout():
	if GameState.lives <= 0:
		owner.emit_ship_exploded()
	else:
		print("Blinking")
		owner.PlayerStateMachine.transition_to("Blinking")

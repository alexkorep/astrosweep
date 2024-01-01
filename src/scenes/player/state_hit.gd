# Idle.gd
extends State

var timer = null
var blink_timer = null

# Upon entering the state, we set the Player node's velocity to zero.
func enter(_msg := {}) -> void:
	timer = Timer.new()
	timer.connect("timeout", self, "hit_finished")
	add_child(timer)
	timer.start(4.0)
	
	get_node("%BlinkTimer").start()
	
func hit_finished():
	# Delete timer child
	timer.queue_free()
	timer = null
	owner.PlayerStateMachine.transition_to("Main")
	get_node("%BlinkTimer").stop()

func exit() -> void:
	pass

func _on_BlinkTimer_timeout():
	var sprite = get_node("%ShipSprite")
	sprite.visible = not sprite.visible

func kill():
	pass

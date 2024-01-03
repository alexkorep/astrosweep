extends PlayerStateMain

func enter(_msg := {}) -> void:
	get_node("%BlinkTimer").start()
	get_node("%BlinkTimeoutTimer").start()
	owner.Ship.show()
	owner.get_node("%Gun").start()

func exit() -> void:
	owner.get_node("%Gun").stop()
	
func _on_BlinkTimer_timeout():
	var sprite = get_node("%ShipSprite")
	sprite.visible = not sprite.visible

func _on_BlinkTimeoutTimer_timeout():
	get_node("%ShipSprite").visible = true
	get_node("%BlinkTimer").stop()
	owner.PlayerStateMachine.transition_to("Main")

func damage():
	# No damage in this state
	return

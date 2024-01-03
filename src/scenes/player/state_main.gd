extends State
class_name PlayerStateMain

func enter(_msg := {}) -> void:
	# TODO would it connect multiple times if we enter this mode multiple times?
	# Should connect be moved to _on_ready?
	owner.get_node("%Gun").start()

func update(delta: float) -> void:
	get_node("%TouchController").update(delta)
	
func handle_input(event: InputEvent) -> void:
	get_node("%TouchController").handle_input(event)
	
func exit() -> void:
	owner.get_node("%Gun").stop()

func damage():
	GameState.decrement_lives()
	owner.PlayerStateMachine.transition_to("Explode")

func powerup(powerup_id):
	if powerup_id == "heart":
		GameState.increment_lives()
	elif powerup_id == "rps":
		owner.increment_rps()
	elif powerup_id == "score":
		GameState.increment_score(100)

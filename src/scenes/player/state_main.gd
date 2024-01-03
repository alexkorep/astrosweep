extends State
class_name PlayerStateMain

var mouse_pressed_position = Vector2.ZERO
var mouse_pressed_ship_position = Vector2.ZERO
var target_move_position = Vector2.ZERO
var mouse_pressed := false

func enter(msg := {}) -> void:
	# TODO would it connect multiple times if we enter this mode multiple times?
	# Should connect be moved to _on_ready?
	owner.get_node("%Gun").start()
	if msg.has("mouse_pressed_position"):
		mouse_pressed_position = msg.mouse_pressed_position
	if msg.has("mouse_pressed_ship_position"):
		mouse_pressed_ship_position = msg.mouse_pressed_ship_position
	if msg.has("target_move_position"):
		target_move_position = msg.target_move_position
	if msg.has("mouse_pressed"):
		mouse_pressed = msg.mouse_pressed


func update(delta: float) -> void:
	if not mouse_pressed:
		return
		
	# Move to target_move_position with owner.max_speed
	var move_vector = target_move_position - owner.position
	var move_vector_length = move_vector.length()
	if move_vector_length > owner.max_speed * delta:
		move_vector = move_vector.normalized() * owner.max_speed * delta
	owner.position += move_vector

	# Keep the player within the screen
	var viewport_rect = owner.get_viewport_rect()
	owner.position.x = clamp(owner.position.x, 0, viewport_rect.size.x)
	owner.position.y = clamp(owner.position.y, 0, viewport_rect.size.y)
	
func handle_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		mouse_pressed_position = event.position if event.pressed else Vector2.ZERO
		mouse_pressed_ship_position = owner.position if event.pressed else Vector2.ZERO
		mouse_pressed = event.pressed
		target_move_position = owner.position
	elif event is InputEventMouseMotion and event.button_mask == 1:
		target_move_position = event.position - mouse_pressed_position + mouse_pressed_ship_position

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

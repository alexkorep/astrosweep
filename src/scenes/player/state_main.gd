extends State

var mouse_pressed_position = Vector2.ZERO
var mouse_pressed_ship_position = Vector2.ZERO
var target_move_position = Vector2.ZERO
var mouse_pressed := false

var bullet_scene = preload("res://scenes/player/player_bullet.tscn")

var blinking = false

func enter(_msg := {}) -> void:
	# TODO would it connect multiple times if we enter this mode multiple times?
	# Should connect be moved to _on_ready?
	owner.ShootTimer.connect("timeout", self, "on_shoot_timer")
	owner.ShootTimer.start()
	on_shoot_timer()
	owner.emit_player_ready()

func on_shoot_timer():
	var b = bullet_scene.instance()
	get_tree().root.add_child(b)
	b.start(owner.GunPosition.global_position)

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
	owner.ShootTimer.stop()

func damage():
	if blinking:
		return

	GameState.decrement_lives()
	if GameState.lives <= 0:
		owner.PlayerStateMachine.transition_to("Explode")
	else:
		blinking = true
		get_node("%BlinkTimer").start()
		get_node("%BlinkTimeoutTimer").start()

func _on_BlinkTimer_timeout():
	var sprite = get_node("%ShipSprite")
	sprite.visible = not sprite.visible

func _on_BlinkTimeoutTimer_timeout():
	blinking = false
	get_node("%ShipSprite").visible = true
	get_node("%BlinkTimer").stop()

func powerup(powerup_id):
	if powerup_id == "heart":
		GameState.increment_lives()
	elif powerup_id == "rps":
		owner.increment_rps()
	elif powerup_id == "score":
		GameState.increment_score(100)

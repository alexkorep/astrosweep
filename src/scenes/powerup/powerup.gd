extends Area2D

export var speed = 150
export var direction = Vector2(0, 20)
export var powerup_id := ""

func _ready():
	for sprite in get_node("%Sprites").get_children():
		sprite.visible = sprite.name == powerup_id
	
func _process(delta):
	position += speed * delta * direction.normalized()

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func _on_area_entered(_area):
	pass

func _on_Powerup_body_entered(body):
	# TODO check if it's a player
	if body.has_method("powerup"):
		body.powerup(powerup_id)
	queue_free()

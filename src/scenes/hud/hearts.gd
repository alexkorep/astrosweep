extends Control


export var count = 3 setget set_count

var heart_scene = preload("res://scenes/hud/heart_image.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	set_count(count)

func set_count(value):
	count = value

	var container = get_node("%HeartsContainer")
	if not container:
		return
		
	if len(container.get_children()) == value:
		return

	for child in container.get_children():
		child.queue_free()

	for _i in range(value):
		var heart = heart_scene.instance()
		container.add_child(heart)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

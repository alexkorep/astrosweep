extends Control

onready var b1 = get_node("%BackgroundSprite1")
onready var b2 = get_node("%BackgroundSprite2")

export var speed = 200 # pixel per sec

# Called when the node enters the scene tree for the first time.
func _ready():
	b1.position.y = 0
	b2.position.y = b1.position.y + b1.texture.get_height()

func _process(delta):
	var shift = speed * delta
	b1.position.y += shift
	b2.position.y += shift
	if b1.position.y > 0:
		b2.position.y = b1.position.y - b1.texture.get_height()
		var tmp = b1
		b1 = b2
		b2 = tmp
	

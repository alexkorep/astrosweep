extends Control

onready var text_label = get_node("%TextLabel")
onready var tween = Tween.new()
onready var timer = get_node("%Timer")

export var text := "Wave"

# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(tween)
	text_label.margin_top = 720
	
func start():
	text_label.text = text
	tween.interpolate_property(text_label, 
		"margin_top", 0, 240, 1, 
		Tween.TRANS_BOUNCE, Tween.EASE_OUT)
	tween.start()
	timer.start()

func _on_Timer_timeout():
	tween.interpolate_property(text_label, 
		"margin_top", 240, 720, 0.3, 
		Tween.TRANS_CIRC, Tween.EASE_IN)
	tween.start()

extends Control

onready var text_label = get_node("%TextLabel")
onready var tween = Tween.new()
onready var timer = get_node("%Timer")

export var text := "Wave"
export var extra = 0

var fading_out = false

signal finished

# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(tween)
	text_label.margin_top = 720
	tween.connect("tween_completed", self, "_on_tween_completed")
	
func start():
	text_label.show()
	text_label.text = text
	tween.interpolate_property(text_label, 
		"margin_top", -50, 240, 1, 
		Tween.TRANS_BOUNCE, Tween.EASE_OUT)
	tween.start()
	timer.start()
	fading_out = false

func _on_Timer_timeout():
	tween.interpolate_property(text_label, 
		"margin_top", 240, 720, 0.3, 
		Tween.TRANS_CIRC, Tween.EASE_IN)
	tween.start()
	fading_out = true


func _on_tween_completed(_object, _key):
	if fading_out:
		emit_signal("finished")
		text_label.hide()

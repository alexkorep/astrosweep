extends AudioStreamPlayer

onready var tween = Tween.new()

func _ready():
	play()
	add_child(tween)
	volume_db = -80
	tween.interpolate_property(self, "volume_db", -30, 0, 2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

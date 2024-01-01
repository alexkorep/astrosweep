extends Control

func _ready():
	$LineEdit.grab_focus()

func _on_Button_pressed():
	var initials = $LineEdit.text
	GameState.add_high_score(initials)
	get_tree().change_scene("res://scenes/high_score/high_score.tscn")

extends PauseMenu

func _ready() -> void:
	$VBoxContainer/ResumeButton.text = "Play again"

func open(message: String = "Gameover") -> void:
	.open(message)

func _first_button_action() -> void:
	get_tree().paused = false
	get_tree().change_scene("res://Game.tscn")



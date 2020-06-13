extends Control
class_name StartScreen

var game_scene := "res://Game.tscn"

func _ready() -> void:
	pass # Replace with function body.

func _on_StartButton_pressed() -> void:
	get_tree().change_scene(game_scene)
	pass # Replace with function body.

func _on_QuitButton_pressed() -> void:
	get_tree().quit()

func _toggle_credits_panel() -> void:
	$CreditsPanel.visible = !$CreditsPanel.visible

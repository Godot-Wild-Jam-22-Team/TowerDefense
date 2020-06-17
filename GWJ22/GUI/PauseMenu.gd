extends Control
class_name PauseMenu

signal open
signal closed

func _ready() -> void:
	set_process_input(false)
	visible = false

func open(message: String = "Pause") -> void:
	$PauseLabel.text = message
	set_process_input(true)
	emit_signal("open")
	show()

func close() -> void:
	emit_signal("closed")
	set_process_input(false)
	hide()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		close() 
		#ISSUE called correctly but not working as with button

func _on_ResumeButton_pressed() -> void:
	_first_button_action()

func _first_button_action() -> void:
	close()

func _on_QuitButton_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene("res://GUI/StartScreen.tscn")
	#get_tree().quit()

extends Node

onready var pause_menu := $PauseScreen/PauseMenu

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		get_tree().set_input_as_handled()
		pause_menu.open()
		set_process_input(false)
		get_tree().paused = true
		yield(pause_menu, "closed")
		set_process_input(true)
		get_tree().paused = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass

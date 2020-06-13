extends Area2D
class_name DraggableObject

signal grabbed_object

var grabbed := false setget set_grabbed

var price := 500.0

func _ready() -> void:
	pass #do not mess with process as it may be used by children

func initialize(position: Vector2, grab : bool = true) -> void:
	global_position = position
	self.grabbed = grab

func _input_event(_viewport: Object, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("main_click"):
		self.grabbed = true
	elif event.is_action_released("main_click"):
		self.grabbed = false
	elif event.is_action_pressed("secondary_click"):
		rotation_degrees += 90

func _process(_delta: float) -> void:
	if grabbed:
		global_position = get_global_mouse_position()

func set_grabbed(value: bool) -> void:
	grabbed = value
	if grabbed:
		emit_signal("grabbed_object")

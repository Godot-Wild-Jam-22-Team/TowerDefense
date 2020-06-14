extends Area2D
class_name DraggableObject

signal dropped(object)

var start_position := Vector2.ZERO #used in case of cancel purchase animation

var grabbed := false setget set_grabbed
var droppable := true setget set_droppable

var flashing_colors := [Color.white, Color.crimson]

var price := 500.0

func _ready() -> void:
	pass #do not mess with process as it may be used by children

func initialize(position: Vector2, grab : bool = true) -> void:
	global_position = position
	self.grabbed = grab

func _input_event(_viewport: Object, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("main_click"):
		self.grabbed = true
	elif event.is_action_pressed("secondary_click"):
		rotation_degrees += 90

func _process(_delta: float) -> void:
	if Input.is_action_just_released("main_click") and droppable:
		self.grabbed = false
	if grabbed:
		global_position = get_global_mouse_position()

func set_grabbed(value: bool) -> void:
	grabbed = value
	if grabbed:
		raise()
	else:
		$DropSound.play()
		emit_signal("dropped", self)

func adjust_position(end_position: Vector2) -> void:
	# used to center in tile with pixel precision
	pass

func cancel_purchase() -> void:
	$ErrorSound.play()
	
	# when there are no enough money animate to report not buyable
	pass

# Manage collisions while dragging

func _on_DraggableObject_area_entered(area: Area2D) -> void:
	self.droppable = false

func _on_DraggableObject_area_exited(area: Area2D) -> void:
	self.droppable = true

func set_droppable(value: bool) -> void:
	droppable = value
	if not grabbed:
		return
	if droppable:
		$Tween.stop_all()
		$Placeholder.modulate = Color.white
		$Sprite.modulate = Color.white
	else:
		_start_tween()

func _start_tween():
	$Tween.interpolate_property(
		$Placeholder, #$Sprite,
		"modulate",
		flashing_colors[0], 
		flashing_colors[1],
		0.3,
		Tween.TRANS_QUAD,
		Tween.EASE_IN_OUT)
	$Tween.start()

func _on_Tween_tween_completed(object: Object, key: NodePath) -> void:
	if key == ":modulate":
		flashing_colors.invert()
		_start_tween()

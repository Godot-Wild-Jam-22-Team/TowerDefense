extends Area2D
class_name DraggableObject

signal dropped(object, price)

export (bool) var repositionable := true #turn of after marketplace event is ended

var start_position := Vector2.ZERO #used in case of cancel purchase animation
var previous_position := Vector2.ZERO

var _grabbed := false setget _set_grabbed
var _droppable := true setget _set_droppable

var flashing_colors := [Color.white, Color.crimson]

var price := 500.0 #set to 0 after first placement

var default_rotation : float = 0.0

func _ready() -> void:
	pass #do not mess with process as it may be used by children

func initialize(position: Vector2, grab : bool = true) -> void:
	self._grabbed = grab
	start_position = position
	previous_position = start_position #same at the beginning
	global_position = start_position

func _input_event(_viewport: Object, event: InputEvent, _shape_idx: int) -> void:
	if repositionable:
		if event.is_action_pressed("main_click"):
			self._grabbed = true
		elif event.is_action_pressed("secondary_click"):
			rotation_degrees += 90
			default_rotation = rotation
	

func _process(_delta: float) -> void:
	if _grabbed:
		global_position = get_global_mouse_position()
		if Input.is_action_just_released("main_click"):
			self._grabbed = false
	

func _set_grabbed(value: bool) -> void:
	_grabbed = value
	if _grabbed:
		previous_position = global_position
		raise()
	else:
		if _droppable:
			$DropSound.play()
			var payment = price if previous_position == start_position else 0.0
			#print("Pay %s" % payment)
			emit_signal("dropped", self, payment)
		else:
			$ErrorSound.play()
			adjust_position(previous_position)

func cancel_purchase() -> void:
	#print("Purchase canceled")
	_start_flash()
	adjust_position(start_position)

func adjust_position(end_position: Vector2) -> void:
	var duration = 2.0
	$Tween.interpolate_property(self, "global_position",
	global_position, end_position, duration, Tween.TRANS_QUAD,Tween.EASE_IN_OUT)
	$Tween.start()
	pass

# Manage collisions while dragging

func _on_DraggableObject_area_entered(area: Area2D) -> void:
#	print("Area entered: %s" % area.name)
	if area.name == "Vision":
		return
	self._droppable = false

func _on_DraggableObject_area_exited(area: Area2D) -> void:
	if area.name == "Vision":
		return
	self._droppable = true

func _set_droppable(value: bool) -> void:
	#print("Changed droppable %s" % value)
	_droppable = value
	if not _grabbed:
		return
	if _droppable:
		_reset_flash()
	else:
		_start_flash()

func _reset_flash() -> void:
	$Tween.stop_all()
	#$Placeholder.modulate = Color.white
	$Sprite.modulate = Color.white

func _start_flash():
	$Tween.interpolate_property(
		$Sprite, #$Sprite,
		"modulate",
		flashing_colors[0], 
		flashing_colors[1],
		0.3,
		Tween.TRANS_QUAD,
		Tween.EASE_IN_OUT)
	$Tween.start()

func _on_Tween_tween_completed(object: Object, key: NodePath) -> void:
	#print("Object %s, key %s" % [object, key])
	if object == self: #adjust position
		if previous_position == start_position:
			queue_free()
		else:
			_reset_flash()
	if key == ":modulate": #flashing color
		flashing_colors.invert()
		_start_flash()

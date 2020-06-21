extends DraggableObject

func _set_droppable(value: bool) -> void:
	#print("Changed droppable %s" % value)
	_droppable = value
	if not _grabbed:
		return
	if not _droppable:
		_reset_flash()
	else:
		_start_flash()

func _get_droppable() -> bool:
	return not _droppable

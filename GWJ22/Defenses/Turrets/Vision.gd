extends Area2D

class_name Vision

signal updated(position)
signal reset()

var enemy_positions = Array()

func _on_Vision_body_entered(body: KinematicBody2D) -> void:
	if body.is_in_group("player"):
		return
	set_process(true)

func _process(_delta: float) -> void:
	
	var candidates = get_overlapping_bodies()
	enemy_positions = []
	for body in candidates:
		if body.is_in_group("foes"):
			enemy_positions.append(body.global_position)
	
	if enemy_positions.size() <= 0:
		set_process(false)
		emit_signal('reset')
		return
	else:
		#sort
		emit_signal('updated', enemy_positions[0])

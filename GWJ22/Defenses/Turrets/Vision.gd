extends Area2D

class_name Vision

signal updated
signal exited

var enemy: KinematicBody2D
var enemy_pos := Vector2(0,0)
var has_focus := false

func _on_Vision_body_entered(body: KinematicBody2D) -> void:
	if body.is_in_group("player"):
		return
	if(has_focus == false):
		has_focus = true
		enemy = body

func _on_Vision_body_exited(body: KinematicBody2D) -> void:
	if body.is_in_group("player"):
		return
	has_focus = false
	emit_signal('exited')

func update_enemy_position() -> void:
	if(has_focus == true):
		emit_signal('updated', enemy.global_position)

func _process(_delta: float) -> void:
	update_enemy_position()

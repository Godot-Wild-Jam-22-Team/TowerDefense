extends Area2D

class_name Vision

signal updated
signal exited

var enemy
var enemy_pos := Vector2(0,0)
var has_focus := false

func _on_Vision_body_entered(body):
	if(has_focus == false):
		has_focus = true
		enemy = body

func _on_Vision_body_exited(body):
	has_focus = false
	emit_signal('exited')

func update_enemy_position() -> void:
	if(has_focus == true):
		emit_signal('updated', enemy.position)

func _process(_delta: float) -> void:
	update_enemy_position()

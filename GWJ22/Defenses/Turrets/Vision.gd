extends Area2D

signal updated
signal exited

var enemy
var enemy_pos = Vector2(0,0)
var has_focus = false

func start(_position, _direction):
	position = _position
	rotation = _direction.angle()

func _on_Vision_body_entered(body):
	if(has_focus == false):
		has_focus = true
		enemy = body

func _on_Vision_body_exited(body):
	has_focus = false
	emit_signal('exited')

func update_enemy_position():
	if(has_focus == true):
		emit_signal('updated', enemy.position)

func _process(delta):
	update_enemy_position()

extends DraggableObject
class_name Turret

signal shoot
signal created

export (float) var gun_cooldown
export (PackedScene) var Bullet
export (PackedScene) var Vision

var can_shoot = true
var has_focused_enemy = false
var focused_enemy_position = Vector2()

func _ready():
	$Guntimer.wait_time = gun_cooldown

func _on_Guntimer_timeout():
	can_shoot = true

func created():
	var dir = $Position2D.position
	emit_signal('created', Vision, position, dir)

func shoot():
	if can_shoot == true:
		can_shoot = false
		$Guntimer.start()
		var dir = Vector2(0,-1).rotated(global_rotation)
		emit_signal('shoot', Bullet, $Position2D.global_position, dir)

func _on_Vision_updated(_position):
	has_focused_enemy = true
	focused_enemy_position = _position
	look_at(focused_enemy_position)

func _on_Vision_exited():
	has_focused_enemy = false

func _process(delta):
	if(has_focused_enemy == true):
		shoot()

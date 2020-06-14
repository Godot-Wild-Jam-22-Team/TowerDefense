extends DraggableObject
class_name Turret

signal shoot
signal created

export (float) var gun_cooldown
export (PackedScene) var Bullet

var can_shoot = true
var has_focused_enemy = false
var focused_enemy_position = Vector2()

func _ready() -> void:
	$Guntimer.wait_time = gun_cooldown

func _on_Guntimer_timeout():
	can_shoot = true

func shoot():
	if can_shoot == true:
		can_shoot = false
		$Guntimer.start()
		var dir = Vector2(0,-1).rotated(global_rotation)
		emit_signal('shoot', Bullet, $Position2D.global_position, dir)

func _process(delta):
	shoot()

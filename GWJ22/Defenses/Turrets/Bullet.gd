extends Area2D

export (int) var speed = 200
export (int) var damage = 1
export (float) var lifetime = 2.0

var velocity = Vector2()

func start(_position, _direction):
	position = _position
	rotation = _direction.angle()
	$Lifetime.wait_time = lifetime
	$Lifetime.start()
	velocity = _direction * speed

func _on_Lifetime_timeout():
	queue_free()

func _process(delta):
	position += velocity * delta


func _on_Bullet_body_entered(body: Node) -> void:
	if body.is_in_group("foes") and body.has_method("take_damage"):
		body.take_damage(damage)
		queue_free()


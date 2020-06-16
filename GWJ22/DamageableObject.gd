extends Area2D
class_name DamageableObject

signal die(object) # used to check game status
signal health_changed(newvalue) #updates progress bars

var health := 4 setget set_health # 10 for 

func take_damage(value: int = 1) -> void:
	health -= value

func die() -> void:
	emit_signal("die", self.name)
	queue_free()

func set_health(value) -> void:
	health = max(0, value)
	emit_signal("health_changed", health)
	if health <= 0:
		die()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass

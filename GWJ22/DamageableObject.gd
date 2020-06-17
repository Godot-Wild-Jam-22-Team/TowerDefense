extends KinematicBody2D
class_name DamageableObject

signal die(name) # used to check game status
signal health_changed(newvalue) #updates progress bars

var health := 4 setget set_health # 10 for 

func take_damage(value: int = 1) -> void:
	#print("%s takes %s damage" % [self.name, value])
	self.health -= value

func die() -> void:
	print("Death of %s" % self.name)
	emit_signal("die", self.name)
	queue_free()

func set_health(value) -> void:
	health = max(0.0, value)
	#print("%s health: %s " % [self.name, health])
	emit_signal("health_changed", health)
	if health <= 0:
		die()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass

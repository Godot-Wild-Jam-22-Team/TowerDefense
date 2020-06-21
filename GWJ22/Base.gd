extends DamageableObject
class_name Base

func _ready() -> void:
	health = 10 #force intialization to update progress bar


func die() -> void:
	$DieSound.play()
	


func _on_DieSound_finished() -> void:
	.die()

extends DamageableObject
class_name Base

func _ready() -> void:
	health = 10 #force intialization to update progress bar


func die() -> void:
	#add animation explosion and call parent at the end, also send info about gameover
	.die()

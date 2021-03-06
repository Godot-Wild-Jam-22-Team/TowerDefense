extends DraggableObject
class_name Turret

signal shoot(bullet_scene, start_position, direction)
#signal created

export (float) var gun_cooldown : float
export (PackedScene) var bullet_scene
onready var vision := $Vision

var can_shoot := true
var has_focused_enemy := false
var focused_enemy_position = Vector2()

func _ready() -> void:
	$Guntimer.wait_time = gun_cooldown

#func _input(event: InputEvent) -> void:
#	if event.is_action_pressed("ui_right"):
#		$Sprite.frame = ($Sprite.frame + 1) % 8

func _on_Guntimer_timeout() -> void:
	can_shoot = true

func shoot() -> void:
	if can_shoot == true:
		can_shoot = false
		$Guntimer.start()
		var direction = Vector2(1,0).rotated(global_rotation)
		emit_signal('shoot', bullet_scene, $Cannon/Emitter.global_position, direction)
		$ShotSound.play()

func _on_Vision_updated(position: Vector2) -> void:
	if position:
		has_focused_enemy = true
		focused_enemy_position = position
		look_at(focused_enemy_position)

func _on_Vision_reset() -> void:
	has_focused_enemy = false
	$RotationTween.interpolate_property(self, "rotation", rotation, default_rotation, 1.5, Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT)
	$RotationTween.start()

func _process(_delta: float) -> void:
	._process(_delta) #call parent execution to allow drag
	if(has_focused_enemy == true):
		shoot()

# Aftermarket health management ( I want to make draggable a child of damageable)
var health := 4 setget set_health # 10 for 

func take_damage(value: int = 1) -> void:
	health -= value

func set_health(value) -> void:
	health = max(0.0, value)
	#call update on progress bar
	if health <= 0:
		print("Turret dead")
		queue_free() #and any animation

#func modified_look_at(position: Vector2) -> void:
#	$Cannon.look_at(position)
#	var degrees = $Cannon.rotation_degrees
#	var idx = (degrees -22.5) / 22.5
#
#	$Sprite.frame = idx

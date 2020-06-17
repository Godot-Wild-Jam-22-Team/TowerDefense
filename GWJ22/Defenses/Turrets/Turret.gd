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

func _on_Guntimer_timeout() -> void:
	can_shoot = true

func shoot() -> void:
	if can_shoot == true:
		can_shoot = false
		$Guntimer.start()
		var direction = Vector2(0,-1).rotated(global_rotation)
		emit_signal('shoot', bullet_scene, $Position2D.global_position, direction)

func _on_Vision_updated(_position: Vector2) -> void:
	has_focused_enemy = true
	focused_enemy_position = _position
	look_at(focused_enemy_position)

func _on_Vision_exited() -> void:
	has_focused_enemy = false

func _process(_delta: float) -> void:
	._process(_delta) #call parent execution to allow drag
	if(has_focused_enemy == true):
		shoot()

# Aftermarket health management ( I want to make draggable a child of damageable)
var health := 4 setget set_health # 10 for 

func take_damage(value: int = 1) -> void:
	health -= value

func set_health(value) -> void:
	health = max(0, value)
	#call update on progress bar
	if health <= 0:
		print("Turret dead")
		queue_free() #and any animation

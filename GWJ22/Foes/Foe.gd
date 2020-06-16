extends DamageableObject

class_name Foe

onready var animation_player := $AnimationPlayer

# Movement
export (float, 50.0, 200.0) var speed := 100.0
var velocity := Vector2.ZERO
var path := PoolVector2Array()

var go_to_point:= Vector2.ZERO

# Attack
export (int, 1, 5) var ATTACK_POWER := 1
var targets = []
var distance_threshold := 5.0

func _ready() -> void:
	initialize(Vector2(200.0, 0.0), Vector2(850.0, 500.0))
	pass # Replace with function body.

func initialize(start_position: Vector2, destination: Vector2) -> void:
	global_position = start_position
	#pick random points along a general path
	
	path.append(Vector2(global_position.x, destination.y))
	# a pivot where to turn and a couple of points in between to variate the path
	
	path.append(destination)
	go_to_point = path[0]


func _process(delta: float) -> void:
	if global_position.distance_to(go_to_point) < distance_threshold:
		go_to_point = next_point()
	
	velocity = go_to_point - global_position
	global_position += velocity.normalized() * speed * delta

func next_point() -> Vector2:
	if targets.size() > 0:
		#iterate to find the nearest one
		var target : Area2D = targets[0]
		return target.global_position
	
	if path.size() > 1:
		path.remove(0)
		return path[0]
	
	return path[0]

# //should also react to damage, so listen for health change signal(?) - I cannot know the direction as bullets are indpeendent objects, unless I follow the incoming direction

# bullets should implement an attack method too when touching an area in foe group

func attack(target: DamageableObject) -> void:
	target.take_damage(ATTACK_POWER)

func _on_View_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		targets.append(area)
		go_to_point = targets[0]

func _on_View_area_exited(area: Area2D) -> void:
	if area.is_in_group("player"):
		var idx = targets.find(area)
		targets.remove(idx)
		if targets.size() > 0:
			go_to_point = targets[0]
		elif path.size() > 0 :
			go_to_point = path[0]

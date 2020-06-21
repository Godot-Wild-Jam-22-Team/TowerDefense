extends DamageableObject

class_name Foe

enum State {IDLE, WALK, ATTACK, DIE}
var current_state = State.IDLE setget set_current_state

onready var animation_player := $AnimationPlayer

var flashing_colors := [Color.white, Color.crimson]
var flash_count_down := 10

# Movement
export (float, 50.0, 200.0) var speed := 100.0
var velocity := Vector2.ZERO
var path := []

# Attack
export (int, 1, 5) var ATTACK_POWER := 1
var targets = []
var distance_threshold := 5.0

func _ready() -> void:
	#randomize()
	#initialize(Vector2(200.0, 0.0), Vector2(850.0, 300.0))
	pass # Replace with function body.

func initialize(start_position: Vector2, destination: Vector2) -> void:
	global_position = start_position

	var turning_point = random_near_point(Vector2(global_position.x, destination.y))
	
	path.append(random_near_point(mid_point(start_position, turning_point)))
	path.append(turning_point)
	path.append(random_near_point(mid_point(turning_point, destination)))

	path.append(destination)
	self.current_state = State.WALK
	#print(path)

func random_near_point(point: Vector2, max_distance: float = 150.0) -> Vector2:
	randomize()
	var distance = randf() * max_distance
	var angle = randf() * 2 * PI
	return point + Vector2(distance*cos(angle), distance*sin(angle))

func mid_point(p1: Vector2, p2: Vector2) -> Vector2:
	return Vector2(p1.x + p2.x, p1.y + p2.y)/2

func _physics_process(_delta: float) -> void:
	var temp_destination := Vector2.ZERO
	match current_state:
		State.WALK:
			if path.size() > 0 and global_position.distance_to(path[0]) < distance_threshold:
				path.remove(0)
			if path.size() <= 0:
				self.current_state = State.IDLE
				return
			temp_destination = path[0]
			look_at(path[0])
			
		State.ATTACK:
			attack(targets[0]) #add a tempo for attack
			return #do not walk after attack (especially if the target dies)
			
	velocity = temp_destination - global_position
	move_and_slide(velocity.normalized() * speed)

# //should also react to damage, so listen for health change signal(?) - I cannot know the direction as bullets are indpeendent objects, unless I follow the incoming direction

# bullets should implement an attack method too when touching an area in foe group

func attack(target: DamageableObject) -> void:
	target.take_damage(ATTACK_POWER)
	die()

func take_damage(value: int = 1) -> void:
	$DamageSound.play()
	.take_damage(value)

func die():
	self.current_state = State.DIE
	$DeathSound.play()
	

func set_current_state(new_state) -> void:
	if new_state == current_state:
		return
	
	current_state = new_state
	
	match current_state:
		State.WALK:
			$AnimationPlayer.play("Walk")
			set_physics_process(true)
		State.ATTACK:
			$AnimationPlayer.play("Idle")
			print("Switched state to Attack")
			set_physics_process(true)
		State.IDLE:
			$AnimationPlayer.play("Idle")
			set_physics_process(false)
		State.DIE:
			set_physics_process(false)
			pass #any animation here

func _on_View_area_entered(area: Area2D) -> void:
	return
	if area.is_in_group("player"):
		targets.append(area)
		self.current_state = State.ATTACK

func _on_View_area_exited(area: Area2D) -> void:
	return
	if area.is_in_group("player"):
		var idx = targets.find(area)
		targets.remove(idx)
		if targets.size() <= 0:
			self.current_state = State.WALK

#Base
func _on_View_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		targets.append(body)
		self.current_state = State.ATTACK


func _on_View_body_exited(body: Node) -> void:
	if body.is_in_group("player"):
		var idx = targets.find(body)
		targets.remove(idx)
		if targets.size() <= 0:
			self.current_state = State.WALK


func _on_DeathSound_finished() -> void:
	.die() #I could need to call this at the end of death animation

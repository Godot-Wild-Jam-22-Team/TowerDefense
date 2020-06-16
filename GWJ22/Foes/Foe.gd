extends DamageableObject

class_name Foe

enum State {IDLE, WALK, ATTACK, DIE}
var current_state = State.IDLE setget set_current_state

onready var animation_player := $AnimationPlayer

# Movement
export (float, 50.0, 200.0) var speed := 100.0
var velocity := Vector2.ZERO
var path := []

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
	self.current_state = State.WALK


func _process(delta: float) -> void:
	var temp_destination := Vector2.ZERO
	match current_state:
		State.WALK:
			if path.size() > 0 and global_position.distance_to(path[0]) < distance_threshold:
				path.remove(0)
			if path.size() <= 0:
				self.current_state = State.IDLE
				return
			temp_destination = path[0]
			
		State.ATTACK:
			temp_destination = targets[0].global_position
			if global_position.distance_to(temp_destination) < distance_threshold:
				attack(targets[0]) #add a tempo for attack
				return #do not walk after attack (especially if the target dies)
			
	velocity = temp_destination - global_position
	global_position += velocity.normalized() * speed * delta

# //should also react to damage, so listen for health change signal(?) - I cannot know the direction as bullets are indpeendent objects, unless I follow the incoming direction

# bullets should implement an attack method too when touching an area in foe group

func attack(target: DamageableObject) -> void:
	#bounce animation
	target.take_damage(ATTACK_POWER)

func _on_View_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		targets.append(area)
		self.current_state = State.ATTACK

func _on_View_area_exited(area: Area2D) -> void:
	if area.is_in_group("player"):
		var idx = targets.find(area)
		targets.remove(idx)
		if targets.size() <= 0:
			self.current_state = State.WALK

func die():
	self.current_state = State.DIE
	.die() #I could need to call this at the end of death animation

func set_current_state(new_state) -> void:
	if new_state == current_state:
		return
	
	current_state = new_state
	
	match current_state:
		State.WALK:
			set_process(true)
		State.ATTACK:
			set_process(true)
		State.IDLE:
			set_process(false)
		State.DIE:
			set_process(false)
			pass #any animation here

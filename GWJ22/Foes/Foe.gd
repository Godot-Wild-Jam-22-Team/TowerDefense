extends Area2D

class_name Foe

onready var animation_player := $AnimationPlayer

# Movement
var speed := 400.0
var velocity := Vector2.ZERO
var path := PoolVector2Array()

# Attack
var target 

# Health
var health := 4

func _ready() -> void:
	pass # Replace with function body.

func initialize(destination: Vector2) -> void:
	#pick random points along a general path
	
	# a pivot where to turn and a couple of points in between to variate the path
	
	path.append(destination)

func take_damage(value: int = 1) -> void:
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass

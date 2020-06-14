extends Node

onready var pause_menu := $PauseScreen/PauseMenu
onready var marketplace := $MarketLayer/Marketplace
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	marketplace.connect("instance_item", self, "add_defense")
	pass # Replace with function body.

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		get_tree().set_input_as_handled()
		pause_menu.open()
		set_process_input(false)
		get_tree().paused = true
		yield(pause_menu, "closed")
		set_process_input(true)
		get_tree().paused = false

func add_defense(item_scene: PackedScene) -> void:
	var new_defense = item_scene.instance()
	$Defenses.add_child(new_defense)
	new_defense.initialize($Navigation2D.get_global_mouse_position(), true)

func _on_Turret_shoot(bullet, _position, _direction):
	var b = bullet.instance()
	add_child(b)
	b.start(_position, _direction)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass




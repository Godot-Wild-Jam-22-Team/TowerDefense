extends Node

onready var wallet : Wallet = $Wallet
onready var pause_menu := $PauseScreen/PauseMenu
onready var marketplace := $MarketLayer/Marketplace

enum State {WAVE, MARKET}
var current_state = State.MARKET

func _ready() -> void:
	wallet.intialize(1000.0)
	marketplace.connect("instance_item", self, "drag_defense")
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

func drag_defense(item_scene: PackedScene) -> void:
	var new_defense : DraggableObject = item_scene.instance()
	$Defenses.add_child(new_defense)
	new_defense.initialize($Navigation2D.get_global_mouse_position(), true)
	#not yet dropped
	new_defense.connect("dropped", self, "drop_defense")

func drop_defense(object: DraggableObject, price: float) -> void:
	if not wallet.remove_amount(price):
		object.cancel_purchase()
		print("Cancel purchase")
		return
	#call adjust position using tile map coordinates
	object.connect("", self, "") #connect shot signal here

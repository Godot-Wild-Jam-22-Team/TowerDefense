extends Node

onready var wallet : Wallet = $Wallet
onready var pause_menu := $PauseScreen/PauseMenu
onready var marketplace := $MarketLayer/Marketplace

enum State {WAVE, MARKET}
var current_state = State.MARKET setget set_state

func _ready() -> void:
	wallet.intialize(1000.0)
	marketplace.connect("instance_item", self, "drag_defense")
	$MarketplaceTimer.start()
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

func drop_defense(defense: Turret, price: float) -> void:
	if not wallet.remove_amount(price):
		defense.cancel_purchase()
		return
	#call adjust position using tile map coordinates
	defense.connect("shoot", self, "_on_Turret_shoot") #connect shot signal here

func set_state(new_state) -> void:
	if new_state == current_state:
		return
	#Exit state logic
	match current_state:
		State.MARKET:
			marketplace.close()
	
	current_state = new_state
	#Enter state logic
	match current_state:
		State.WAVE:
			print("Start Wave phase")
		State.MARKET:
			print("Start Market phase")
			marketplace.open()
			$MarketplaceTimer.start()

func _on_Turret_shoot(bullet_scene, _position: Vector2, _direction: Vector2):
	var bullet = bullet_scene.instance()
	$Bullets.add_child(bullet)
	bullet.start(_position, _direction)

func _on_MarketplaceTimer_timeout() -> void:
	self.current_state = State.WAVE #no more money (test)

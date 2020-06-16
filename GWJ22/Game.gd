extends Node

onready var wallet : Wallet = $Wallet
onready var pause_menu := $PauseScreen/PauseMenu
onready var marketplace := $MarketLayer/Marketplace

export (PackedScene) var enemy_scene
var base_position := Vector2(850.0, 300.0) #replace with actual base

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

func set_state(new_state) -> void:
	if new_state == current_state:
		return
	#Exit state logic
	match current_state:
		State.WAVE:
			print("Reward player")
			# add count to limit number of repetitions
		State.MARKET:
			marketplace.close()
	
	current_state = new_state
	#Enter state logic
	match current_state:
		State.WAVE:
			print("Start Wave phase")
			_start_wave()
		State.MARKET:
			print("Start Market phase")
			marketplace.open()
			$MarketplaceTimer.start()

# FIGHT SCENE

func _start_wave(enemies_count: int = 3) -> void:
	randomize()
	for i in enemies_count:
		var new_enemy : Foe = enemy_scene.instance()
		$Enemies.add_child(new_enemy)
		var start_point = Vector2(randf() * 100.0 + 150.0, 0.0)
		new_enemy.initialize(start_point, base_position)
		new_enemy.connect("die", self, "check_game")
	
	# spawn enemies according to count
	# for each new enemy:
	#	instance, 
	#	add to $Enemies
	#	set a random path (We don't want them to proceed in line)
	#   new_enemy.connect("die", self, "check_game")
	
	pass

func _on_Defense_shoot(bullet_scene, _position: Vector2, _direction: Vector2):
	var bullet = bullet_scene.instance()
	$Bullets.add_child(bullet)
	bullet.start(_position, _direction)


func check_game() -> void:
	print("Checking game")
	# count children in $Enemies
	# if 0: self.state = State.MARKET
	
	pass

func gameover() -> void:
	#we could pass a count of enemies destroyed and other stats
	#show gameover scene with options like in pause
	pass

# MARKET RELATED PHASE

func _on_MarketplaceTimer_timeout() -> void:
	self.current_state = State.WAVE #no more money (test)

func drag_defense(item_scene: PackedScene) -> void:
	var new_defense : DraggableObject = item_scene.instance()
	$Defenses.add_child(new_defense)
	new_defense.initialize($Navigation2D.get_global_mouse_position(), true)
	#not yet dropped
	new_defense.connect("dropped", self, "drop_defense")
	new_defense.connect("shoot", self, "_on_Defense_shoot")

func drop_defense(defense: Turret, price: float) -> void:
	if not wallet.remove_amount(price):
		defense.cancel_purchase()
		return
	# enable code here(?)

extends Node

onready var wallet : Wallet = $Wallet
onready var pause_menu := $PauseScreen/PauseMenu
onready var gameover_menu := $PauseScreen/GameoverMenu
onready var marketplace := $MarketLayer/Marketplace

export (PackedScene) var enemy_scene

export (int, 3, 20) var left_wave_count := 3

enum State {WAVE, MARKET}
var current_state = State.MARKET setget set_state

var enemy_count := 0
export (int, 1, 10) var wave_group := 5

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

func _start_wave() -> void:
	randomize()
	left_wave_count -= 1
	var enemies_count = (3-left_wave_count) * wave_group
	var base_position = $Base.global_position
	for i in enemies_count:
		enemy_count += 1
		var new_enemy : Foe = enemy_scene.instance()
		$Enemies.add_child(new_enemy)
		#var start_point = Vector2(randf() * 100.0 + 150.0, 0.0)
		var start_point = Vector2(randi() % (192 - 64 + 1) + 64,0.0)
		new_enemy.initialize(start_point, base_position)
		new_enemy.connect("die", self, "_on_enemy_die")
		yield(get_tree().create_timer(2.0), "timeout")


func _on_Defense_shoot(bullet_scene, _position: Vector2, _direction: Vector2):
	var bullet = bullet_scene.instance()
	$Bullets.add_child(bullet)
	bullet.start(_position, _direction)



func check_game() -> void:
	if enemy_count <= 0:
		wallet.add_amount(1500)
		if left_wave_count <= 0:
			gameover()
		else:
			self.current_state = State.MARKET

func gameover(message: String = "Gameover") -> void:
	print("Game Over: %s" % message)
	gameover_menu.open()
	set_process_input(false)
	get_tree().paused = true
	yield(gameover_menu, "closed")
	set_process_input(true)
	get_tree().paused = true

# MARKET RELATED PHASE

func _on_MarketplaceTimer_timeout() -> void:
	if enemy_count == 0:
		$PauseScreen/StartWave.visible = true
	#print(enemy_count)
	#self.current_state = State.WAVE #no more money (test)

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

func _on_enemy_die(name:String) -> void:
	enemy_count -= 1
	check_game()

func _on_Base_die(name: String) -> void:
	gameover("You lost!")


func _on_StartWave_pressed() -> void:
	$PauseScreen/StartWave.visible=false
	self.current_state = State.WAVE #no more money (test)

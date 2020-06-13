extends Control

signal instance_item(item_scene)

onready var items := $Items.get_children()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for market_item in items:
		market_item.connect("bought_item", self, "buy_item")
	pass # Replace with function body.

func open() -> void:
	show()
	#animate  slide

func close() -> void:
	#animate  slide
	hide()

func buy_item(item_scene: PackedScene) -> void:
	#check price and available money
	#if ok, emit signal to instatiate scene in game
	emit_signal("instance_item", item_scene)
	print ("Market buy action")
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass

tool
extends Button
class_name MarketItem

signal bought_item(scene)

export (PackedScene) var item_scene

onready var name_label := $NameLabel
onready var price_label := $PriceLabel

func _get_configuration_warning() -> String:
	if not item_scene:
		return "Missing item scene"
	return ""

func _ready() -> void:
	#check automatic loading for item info
	pass

func _on_MarketItem_button_down() -> void:
	emit_signal("bought_item", item_scene)

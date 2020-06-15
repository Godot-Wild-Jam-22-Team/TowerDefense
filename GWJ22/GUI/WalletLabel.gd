extends Label



func _on_Wallet_amount_changed(value) -> void:
	text = str(value) + "$"

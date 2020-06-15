extends Node

class_name Wallet

signal amount_changed(value)

export (float) var _amount := 0.0 setget set_amount

func intialize(value:float) -> void:
	self._amount = value

func add_amount(value: float) -> void:
	self._amount += value

func remove_amount(value: float) -> bool:
	if value > _amount:
		return false
	self._amount -= value
	return true

func set_amount(value: float) -> void:
	_amount = max(0.0, value)
	emit_signal("amount_changed", _amount)

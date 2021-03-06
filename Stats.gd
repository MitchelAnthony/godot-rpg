extends Node
class_name Stats

export var max_health := 1
onready var health := max_health setget set_health

signal no_health

func set_health(value: int) -> void:
	health = value
	if health <= 0:
		emit_signal("no_health")

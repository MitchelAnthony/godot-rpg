extends Area2D
class_name Hurtbox

export var show_hit := true

const HitEffect = preload("res://Effects/HitEffect.tscn")

func _on_Hurtbox_area_entered(area: Area2D):
	if not show_hit:
		return

	var effect := HitEffect.instance()
	var main := get_tree().current_scene
	main.add_child(effect)
	effect.global_position = global_position

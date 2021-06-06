extends Area2D
class_name PlayerDetectionZone

var player: Player = null

func can_see_player() -> bool:
	return player != null

func _on_PlayerDetectionZone_body_entered(body: Player):
	player = body

func _on_PlayerDetectionZone_body_exited(body):
	player = null

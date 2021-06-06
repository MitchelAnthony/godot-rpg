extends KinematicBody2D
class_name Bat

const EnemyDeathEffect = preload("res://Effects/EnemyDeathEffect.tscn")

export var ACCELERATION := 300
export var MAX_SPEED := 50
export var FRICTION := 200

enum {
	IDLE,
	WANDER,
	CHASE
}

var velocity := Vector2.ZERO
var knockback := Vector2.ZERO
var state := IDLE

onready var stats = $Stats as Stats
onready var playerDetectionZone = $PlayerDetectionZone as PlayerDetectionZone
onready var animated_sprite = $AnimatedSprite as AnimatedSprite

func _physics_process(delta: float) -> void:
	knockback = knockback.move_toward(Vector2.ZERO, 200 * delta)
	knockback = move_and_slide(knockback)
	
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			seek_player()

		WANDER:
			pass

		CHASE:
			var player = playerDetectionZone.player
			if player != null:
				var direction: Vector2 = (player.global_position - global_position).normalized()
				velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
			else:
				state = IDLE

			animated_sprite.flip_h = velocity.x < 0

	velocity = move_and_slide(velocity)

func seek_player() -> void:
	if playerDetectionZone.can_see_player():
		state = CHASE

func _on_Hurtbox_area_entered(area: SwordHitbox) -> void:
	stats.health -= area.damage
	knockback = (global_position - area.global_position).normalized() * -150

func _on_Stats_no_health():
	queue_free()
	var enemyDeathEffect = EnemyDeathEffect.instance()
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.global_position = global_position

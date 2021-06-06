extends KinematicBody2D
class_name Player

const ACCELERATION = 500
const MAX_SPEED = 100
const FRICTION = 500

enum  States {
	MOVE,
	ROLL,
	ATTACK
}

var state = States.MOVE
var velocity := Vector2.ZERO

onready var animation_player := $AnimationPlayer as AnimationPlayer
onready var animation_tree := $AnimationTree as AnimationTree
onready var animation_state := animation_tree.get("parameters/playback") as AnimationNodeStateMachinePlayback

func _ready() -> void:
	animation_tree.active = true

func _physics_process(delta: float) -> void:
	match state:
		States.MOVE:
			move_state(delta)

		States.ROLL:
			pass

		States.ATTACK:
			attack_state(delta)

func move_state(delta: float) -> void:
	var input_vector := Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		animation_tree.set("parameters/Idle/blend_position", input_vector)
		animation_tree.set("parameters/Run/blend_position", input_vector)
		animation_tree.set("parameters/Attack/blend_position", input_vector)
		animation_state.travel("Run")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		animation_state.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)

	velocity = move_and_slide(velocity)
	
	if Input.is_action_just_pressed("attack"):
		state = States.ATTACK
	
func attack_state(delta: float) -> void:
	velocity = Vector2.ZERO
	animation_state.travel("Attack")

func attack_animation_finished() -> void:
	state = States.MOVE

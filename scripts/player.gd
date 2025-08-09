extends CharacterBody2D


const SPEED = 60.0
const JUMP_VELOCITY = -140.0
var previous_dir: int

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	
	#Animation for Walking (Left or Right)
	if direction == 0:
		if previous_dir < 0:
			animated_sprite_2d.play("left-idle")
		else:
			animated_sprite_2d.play("right-idle")
		velocity.x = move_toward(velocity.x, 0, SPEED)
	elif direction > 0:
		animated_sprite_2d.play("right-walk")
		velocity.x = direction * SPEED
		previous_dir = direction
	elif direction < 0:
		animated_sprite_2d.play("left-walk")
		velocity.x = direction * SPEED
		previous_dir = direction

	move_and_slide()

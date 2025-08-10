extends CharacterBody2D


const SPEED = 60.0
const JUMP_VELOCITY = -140.0

var previous_dir: int = 1
var dashCD: bool = false
var dashingPlayer: bool = false
var dashDirection: int
var dashMul

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var dash_duration: Timer = $dashDuration
@onready var dash_cd: Timer = $dashCD

func _physics_process(delta: float) -> void:
	var dashMultiplicator = 3.5
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("left", "right")
	
	# Animation for Walking (Left or Right) as well as Logic for Walking
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
		
	# Handle dash.
	if Input.is_action_just_pressed("dash") and not dashCD:
		dashDirection = 1 if previous_dir > 0 else -1
		dashingPlayer = true
		dashCD = true
		dash_duration.start()
		dash_cd.start()
	
	if dashingPlayer:
		velocity.x = dashDirection * SPEED * dashMultiplicator
		velocity.y = 0
	elif direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	move_and_slide()

func _on_dash_duration_timeout() -> void:
	dashingPlayer = false

func _on_dash_cd_timeout() -> void:
	dashCD = false

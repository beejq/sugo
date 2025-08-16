extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var dash_timer: Timer = $dashTimer
@onready var dash_effect_timer: Timer = $dashEffectTimer
@onready var dash_cd: Timer = $dashCD
@onready var jump_sfx: AudioStreamPlayer2D = $JumpSFX
@onready var double_jump_sfx: AudioStreamPlayer2D = $doubleJumpSFX
@onready var dash_sfx: AudioStreamPlayer2D = $DashSFX
@onready var spin: AnimationPlayer = $spin


var SPEED : float = 200.0
const JUMP_VELOCITY = -400.0

var isSprinting : bool = false
var doDash : bool = false
var dashDirection: int
var dashCooldown: bool = false
var jumpAmount = 2
var jumpCounter = 0
var was_airbourne : bool = false

const springJumpHeight = -500

func _physics_process(delta: float) -> void:
	
	var dashMultiplicator = 2.5
	
	#Squash and Stretch
	if is_on_floor():
		if was_airbourne:
			was_airbourne = false
			animated_sprite_2d.scale = Vector2(1.6, 0.5) # exaggerated squish

			var tween := create_tween()
			tween.tween_property(animated_sprite_2d, "scale", Vector2.ONE, 0.15) \
				.set_trans(Tween.TRANS_SINE) \
				.set_ease(Tween.EASE_OUT)
	else:
		velocity += get_gravity() * delta  # apply gravity (Vector2)
		was_airbourne = true
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	# Reset double jump when touching floor	
	if is_on_floor():
		jumpCounter = 0
		spin.stop()
		
	# Jump and Double Jump
	if Input.is_action_just_pressed("jump") and jumpCounter < jumpAmount:
		animated_sprite_2d.scale = Vector2(1.6, 0.5)
		double_jump()
		if jumpCounter > 1:
			spin.play("spin")
			double_jump_sfx.play()
		else:
			jump_sfx.play()
			
	# Get the input direction and handle the movement/deceleration. (left -1, none 0, right 1)
	var direction := Input.get_axis("left", "right")
		
	# Flip based on direction and cancel sprint on sharp change
	if direction != 0:
		var moving_right = velocity.x > 0 #returns true if on the right
		var moving_left = velocity.x < 0 #returns true if on the left
		var input_right = direction > 0 #returns true if pressing right
		var input_left = direction < 0 #returns true if pressing left

		# Flip sprite
		animated_sprite_2d.flip_h = input_left #true if left thus will flip

		# if sprinting and moving right but you press left, cancel sprint
		# if sprinting and moving left but you press right, cancel sprint
		if isSprinting and ((moving_right and input_left) or (moving_left and input_right)):
			isSprinting = false
			SPEED = 50
			animated_sprite_2d.play("slide")
			
	# Sprint logic
	if Input.is_action_pressed("sprint") and direction != 0:
		isSprinting = true
		SPEED += delta * 80  # accelerates faster
		SPEED = min(SPEED, 250)
	else:
		SPEED -= delta * 80
		SPEED = max(SPEED, 120)	
	
	# Play animation
	if not animated_sprite_2d.is_playing() or animated_sprite_2d.animation != "slide":
		if is_on_floor():
			if direction == 0:
				animated_sprite_2d.play("idle")
			else:
				animated_sprite_2d.play("walk")
		else:
			animated_sprite_2d.play("jump")
			
	# Dash logic
	if Input.is_action_just_pressed("dash") and not dashCooldown:
		dashDirection = -1 if animated_sprite_2d.flip_h else 1
		doDash = true
		dashCooldown = true
		dash_sfx.play()
		dash_timer.start()
		dash_effect_timer.start()
		dash_cd.start()
	
	if doDash:
		velocity.x = dashDirection * SPEED * dashMultiplicator
		velocity.y = 0
	elif direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
	animated_sprite_2d.scale.x = move_toward(animated_sprite_2d.scale.x, 1, 3 * delta)
	animated_sprite_2d.scale.y = move_toward(animated_sprite_2d.scale.y, 1, 1 * delta)
	
func _on_dash_timer_timeout() -> void:
	doDash = false
	dash_effect_timer.stop()
	
func _on_dash_cd_timeout() -> void:
	dashCooldown = false
	
func double_jump():
	velocity.y = JUMP_VELOCITY
	jumpCounter = jumpCounter + 1
	
func die():
	pass

extends CharacterBody2D

# --- Nodes ---
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var dash_timer: Timer = $dashTimer
@onready var dash_effect_timer: Timer = $dashEffectTimer
@onready var dash_cd: Timer = $dashCD
@onready var jump_sfx: AudioStreamPlayer2D = $JumpSFX
@onready var double_jump_sfx: AudioStreamPlayer2D = $doubleJumpSFX
@onready var dash_sfx: AudioStreamPlayer2D = $DashSFX
@onready var spin: AnimationPlayer = $spin
@onready var coyote_timer: Timer = $CoyoteTimer
@onready var move_while_wall_jumping_cd: Timer = $MoveWhileWallJumpingCD
@onready var world_border: StaticBody2D = $"../world_border"
@onready var world_border_2: StaticBody2D = $"../world_border2"
@onready var dust = preload("res://scenes/dust.tscn")
@onready var dust_location: Marker2D = $Marker2D


# --- Configurable stats ---
@export var SPEED : float = 200.0
@export var JUMP_VELOCITY = -300.0
const DASH_MULTIPLIER := 2.5
const COYOTE_TIME := 0.15
const JUMP_BUFFER_TIME := 0.15
const WALL_JUMP_PUSHBACK = 100
var WALL_SLIDE_GRAVITY = 80

const DASH_AMT: float = 450.0
const DASH_TIME: float = 0.16

var can_dash: bool = true
var is_dashing: bool = false
var dash_dir: Vector2 = Vector2.RIGHT
var dash_timer2: float = 0.0

var dash_freeze_time := 0.05  # freeze before dash
var dash_trail_interval := 0.03
var dash_trail_timer := 0.0

# --- State ---
var isSprinting: bool = false
var doDash: bool = false
var dashDirection: int
var dashCooldown: bool = false
var isWallJumping: bool = false
var isGrounded: bool = true

var jumpAmount := 2
var jumpCounter := 0
var was_airborne: bool = false

# --- Jump buffer vars ---
var jump_buffer_timer := 0.0


func _physics_process(delta: float) -> void:
	
	# Particle Effect on Landing
	
	if isGrounded == false and is_on_floor() == true:
		var instance = dust.instantiate()
		instance.global_position = dust_location.global_position
		get_parent().add_child(instance)
		
	isGrounded = is_on_floor()
	
	# -----------------------
	# Update timers
	# -----------------------
	if jump_buffer_timer > 0:
		jump_buffer_timer -= delta

	# -----------------------
	# Handle jump input
	# -----------------------
	if Input.is_action_just_pressed("jump"):
		jump_buffer_timer = JUMP_BUFFER_TIME

	if jump_buffer_timer > 0 and jumpCounter < jumpAmount and (is_on_floor() or !coyote_timer.is_stopped() or jumpCounter > 0):
		# First jump
		if jumpCounter == 0:
			jump_sfx.play()
		# Double jump
		else:
			spin.play("spin")
			double_jump_sfx.play()

		velocity.y = JUMP_VELOCITY
		jumpCounter = clamp(jumpCounter + 1, 0, jumpAmount)
		jump_buffer_timer = 0.0

	# -----------------------
	# Grounded / Airborne
	# -----------------------
	if is_on_floor() or !coyote_timer.is_stopped():
		
		if !is_dashing and !can_dash:
			can_dash = true
			update_dash_visuals()
		
		isWallJumping = false
		if was_airborne:
			# Landed → reset jumps
			jumpCounter = 0
			spin.stop()
			was_airborne = false

			# Squash & stretch
			animated_sprite_2d.scale = Vector2(1.6, 0.5)
			var tween := create_tween()
			tween.tween_property(animated_sprite_2d, "scale", Vector2.ONE, 0.15) \
				.set_trans(Tween.TRANS_SINE) \
				.set_ease(Tween.EASE_OUT)
	else:
		velocity += get_gravity() * delta
		was_airborne = true
	
	# -----------------------
	# Wall Jump and Wall Slide
	# -----------------------
	if is_on_wall_only() and Input.is_action_just_pressed("jump"):
		var collision := get_slide_collision(0)
		if collision:
			var collider = collision.get_collider()
			# Only allow wall jump if not the world border
			if collider.name != "world_border" and collider.name != "world_border2":
				animated_sprite_2d.play("sliding")
				move_while_wall_jumping_cd.start()
				isWallJumping = true
				velocity.y = JUMP_VELOCITY
				spin.stop()

				var wall_normal = get_wall_normal()
				velocity.x = wall_normal.x * WALL_JUMP_PUSHBACK
		
	if is_on_wall_only() and Input.get_axis("left", "right"):
		var collision := get_slide_collision(0)
		if collision:
			var collider = collision.get_collider()
			# 🚫 Prevent wall slide if it's the world border
			if collider.name != "world_border":
				velocity.y = min(velocity.y, WALL_SLIDE_GRAVITY)
				animated_sprite_2d.play("sliding")

	# -----------------------
	# Variable jump height
	# -----------------------
	if velocity.y < 0 and not Input.is_action_pressed("jump"):
		velocity.y += get_gravity().y * delta * 2.5  # Cut short if button released

	# -----------------------
	# Horizontal movement
	# -----------------------
	var direction := Input.get_axis("left", "right")

	# Flip + cancel sprint if sharp turn
	if direction != 0:
		var input_left = direction < 0
		animated_sprite_2d.flip_h = input_left
#
		#if isSprinting and ((velocity.x > 0 and input_left) or (velocity.x < 0 and not input_left)):
			#isSprinting = false
			#SPEED = 50
			#animated_sprite_2d.play("slide")

	# Sprint logic 
	#if Input.is_action_pressed("sprint") and direction != 0:
		#isSprinting = true
		#SPEED = min(SPEED + delta * 80, 250)
	#else:
		#SPEED = max(SPEED - delta * 80, 120)

	# -----------------------
	# Animations
	# -----------------------
	if not animated_sprite_2d.is_playing() or animated_sprite_2d.animation != "slide":
		if is_on_floor():
			animated_sprite_2d.play("idle" if direction == 0 else "walk")
		else:
			animated_sprite_2d.play("jump")

	# -----------------------
	# Dash logic
	# -----------------------
	#if Input.is_action_just_pressed("dash") and not dashCooldown:
		#dashDirection = -1 if animated_sprite_2d.flip_h else 1
		#doDash = true
		#dashCooldown = true
		#dash_sfx.play()
		#dash_timer.start()
		#dash_effect_timer.start()
		#dash_cd.start()

	#if doDash:
		#velocity.x = dashDirection * SPEED * DASH_MULTIPLIER
		#velocity.y = 0
	if direction and not isWallJumping:
		velocity.x = direction * SPEED
	elif not isWallJumping:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	dash_logic(delta)

	# -----------------------
	# Apply movement
	# -----------------------
	var was_on_floor = is_on_floor()
	move_and_slide()
	if was_on_floor and not is_on_floor():
		coyote_timer.start(COYOTE_TIME)

	# Reset squash/stretch smoothly
	animated_sprite_2d.scale.x = move_toward(animated_sprite_2d.scale.x, 1, 3 * delta)
	animated_sprite_2d.scale.y = move_toward(animated_sprite_2d.scale.y, 1, 1 * delta)


# -----------------------
# Signals
# -----------------------
func _on_dash_timer_timeout() -> void:
	doDash = false
	dash_effect_timer.stop()

func _on_dash_cd_timeout() -> void:
	dashCooldown = false

func _on_move_while_wall_jumping_cd_timeout() -> void:
	isWallJumping = false

# -----------------------
# Helpers
# -----------------------
#func double_jump():
	#velocity.y = JUMP_VELOCITY
	#jumpCounter = clamp(jumpCounter + 1, 0, jumpAmount)

func die():
	pass
	
func dash_logic(delta: float) -> void:
	
	var input_dir: Vector2 = Vector2(
		Input.get_axis("left", "right"),
		Input.get_axis("jump", "ui_down")
	).normalized()
	
	if input_dir.x != 0:
		dash_dir.x = input_dir.x
		
	if can_dash and Input.is_action_just_pressed("dash"):
		var final_dash_dir: Vector2 = dash_dir
		if input_dir.y != 0 and input_dir.x == 0:
			final_dash_dir.x = 0
		final_dash_dir.y = input_dir.y
		
		can_dash = false
		is_dashing = true
		dash_timer2 = DASH_TIME
		
		update_dash_visuals()
		dash_dir = final_dash_dir.normalized()
		
	if is_dashing:
		if not Input.is_action_just_pressed("jump"):
			velocity = dash_dir * DASH_AMT
		dash_timer2 -= delta
		if dash_timer2 <= 0.0:
			is_dashing = false
			velocity *= 0.3  # keep a little leftover momentum

func update_dash_visuals() -> void:
	if can_dash:
		modulate = Color("ffffff")
	else:
		modulate = Color("5d6060")

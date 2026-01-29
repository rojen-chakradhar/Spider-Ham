extends CharacterBody2D

@onready var coyote_timer: Timer = $CoyoteTimer
@onready var jump_buffer_timer: Timer = $JumpBufferTimer
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var coyote_time_activated: bool = false

const jump_height: float = -230.0
var gravity: float = 14.0
const max_gravity: float = 14.5

const max_speed: float = 80
const acceleration: float = 12.5
const friction: float = 4.5


func _physics_process(delta: float) -> void:
	var x_input: float = Input.get_action_strength("right") - Input.get_action_strength("left")
	var velocity_weight: float = delta * (acceleration if x_input else friction)
	velocity.x = lerp(velocity.x, x_input * max_speed, velocity_weight)
	
	if is_on_floor():
		coyote_time_activated = false
		gravity = lerp(gravity, 12.0, 12.0 * delta)
	else:
		if coyote_timer.is_stopped() and !coyote_time_activated:
			coyote_timer.start()
			coyote_time_activated = true

		if Input.is_action_just_released("jump") and is_on_ceiling():
			velocity.y *= 0.5
		
		gravity = lerp(gravity, max_gravity, 12.0 * delta)
		
	if Input.is_action_just_pressed("jump"):
		if jump_buffer_timer.is_stopped():
			jump_buffer_timer.start()
			
	if !jump_buffer_timer.is_stopped() and (!coyote_timer.is_stopped() or is_on_floor()):
		velocity.y = jump_height
		jump_buffer_timer.stop()
		coyote_timer.stop()
		coyote_time_activated = true
	
	if velocity.y < jump_height/2.0:
		var head_collusion: Array = [$Left_HeadNudge.is_colliding(), $Left_HeadNudge2.is_colliding(),$Right_HeadNudge.is_colliding(), $Right_HeadNudge2.is_colliding()]
		if head_collusion.count(true) == 1:
			if head_collusion[0]:
				global_position.x += 1.75
			if head_collusion[2]:
				global_position.x -= 1.75
	
	if velocity.y > -30 and velocity.y < -5 and abs(velocity.x) > 3:
		if $Left_LedgeHop.is_colliding() and !$Left_LedgeHop2.is_colliding() and velocity.x < 0:
			velocity.y += jump_height/3.25
		if $Right_LedgeHop.is_colliding() and !$Right_LedgeHop2.is_colliding() and velocity.x > 0:
			velocity.y += jump_height/3.25
		
	velocity.y += gravity


	move_and_slide()

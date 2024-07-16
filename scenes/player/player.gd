extends Area2D

class_name Player

signal update_energy(max_energy: int, energy: int)

@export var starting_speed: float = 10.0
@export var acceleration: float = 5.0
#@export var max_speed: float = 200.0
@export var max_speed_stages: int = 5
@export var max_energy: int = 3

var velocity: Vector2
var speed_stage: int = 0
var energy: int
var lane: int = 1 # Start in the middle lane

@export var acceleration_timer: Timer
@export var movement_timer: Timer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Set our initial velocity
	velocity = Vector2.UP * starting_speed
	# Signal to update our energy
	energy = max_energy
	update_energy.emit(max_energy, energy)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	update_position()
	lerp_sprite_to_hitbox(delta, 30.0)

# When the acceleration timer expires, accelerate
func _on_acceleration_timer_timeout() -> void:
	accelerate()

# Respond to collisions with other game objects
func _on_area_entered(area: Area2D) -> void:
	pass # Replace with function body.

# Main inputs are move left and move right. We need to update our current lane when these are
# pressed, as well as activate a short cooldown for movement.
func _input(ev) -> void:
	# If we are on movement cooldown, ignore the button press.
	if not $MovementTimer.is_stopped():
		return
	
	# We're using just_pressed to avoid spam of movement and loss of control
	# The lanes are 100 units apart from each other, so just translate our current position
	if Input.is_action_pressed("move_left") and lane > 0:
		lane -= 1
		strafe_left()
		$MovementTimer.start()
	elif Input.is_action_pressed("move_right") and lane < 2:
		lane += 1
		strafe_right()
		$MovementTimer.start()



# Add our velocity to our current position
func update_position() -> void:
	global_position += velocity

# Add our acceleration value to our velocity and limit that speed to our max_speed
func accelerate() -> void:
	#velocity = Vector2(velocity + (velocity.normalized() * acceleration)).limit_length(max_speed)
	if speed_stage < max_speed_stages:
		velocity += (velocity.normalized() * acceleration)

func strafe_left() -> void:
	#$Sprite2D.translate(Vector2.LEFT * 100)
	$CollisionShape2D.translate(Vector2.LEFT * 100)

func strafe_right() -> void:
	#$Sprite2D.translate(Vector2.RIGHT * 100)
	$CollisionShape2D.translate(Vector2.RIGHT * 100)

func lerp_sprite_to_hitbox(delta: float, follow_speed: float) -> void:
	$Sprite2D.position = $Sprite2D.position.lerp($CollisionShape2D.position, delta * follow_speed)

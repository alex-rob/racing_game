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

@export var acceleration_timer: Timer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Set our initial velocity
	velocity = Vector2.UP * starting_speed
	# Signal to update our energy
	update_energy.emit(max_energy, energy)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	update_position()

# When the acceleration timer expires, accelerate
func _on_acceleration_timer_timeout() -> void:
	accelerate()

# Respond to collisions with other game objects
func _on_area_entered(area: Area2D) -> void:
	pass # Replace with function body.



# Add our velocity to our current position
func update_position() -> void:
	global_position += velocity

# Add our acceleration value to our velocity and limit that speed to our max_speed
func accelerate() -> void:
	#velocity = Vector2(velocity + (velocity.normalized() * acceleration)).limit_length(max_speed)
	if speed_stage < max_speed_stages:
		velocity += (velocity.normalized() * acceleration)

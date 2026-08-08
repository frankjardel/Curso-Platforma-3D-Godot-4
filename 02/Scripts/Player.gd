extends CharacterBody3D

@export var walk: float = 4
@export var run: float = 8
var speed: float = walk

@export var acceleration: float = 15
@export var air_acceleration: float = 25
@export var gravity: float = 0.8
@export var max_terminal_velocity: float = 30

@export var JUMP_POWER: float = 14
@export var MAX_JUMPS: int = 1
var count_jumps: int = 0

var y_velocity: float
var direction: Vector3


func _physics_process(delta: float) -> void:
	direction = Vector3()
	
	if Input.is_action_pressed("run"):
		speed = run
	else:
		speed = walk
	
	if Input.is_action_pressed("left"):
		direction.x = -speed
	if Input.is_action_pressed("right"):
		direction.x = speed
	if Input.is_action_pressed("front"):
		direction.z =-speed
	if Input.is_action_pressed("back"):
		direction.z = speed
	
	direction = direction.normalized()
	
	var accel = acceleration if is_on_floor() else air_acceleration
	velocity = velocity.lerp(direction * speed, accel * delta) # velocity = reservada
	
	if is_on_floor():
		y_velocity = -0.01
		count_jumps = 0
	else:
		y_velocity = clamp(y_velocity - gravity, -max_terminal_velocity, max_terminal_velocity)
	
	if Input.is_action_just_pressed("jump") and count_jumps <= MAX_JUMPS:
		y_velocity = JUMP_POWER
		count_jumps += 1
	
	velocity.y = y_velocity
	
	# fazer o personagem parar de forma suave
	if !direction:
		velocity.x = move_toward(velocity.x, 0, delta)
		velocity.y = move_toward(velocity.z, 0, delta)
	
	move_and_slide()

extends CharacterBody2D

var SPEED = 4.3 # default mob speed, override

# status booleans
var isStunned : bool = false # metal, prevent movement
var isBurning : bool = false # set damage over time
var isSlowed  : bool = false # water, reduce move speed
var isRooted  : bool = false # wood, reduce action speed

@onready var stunTimer : Timer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	stunTimer = Timer.new()
	
	if isBurning:
		take_damage(0.5, null, _delta)


# abstract class, please implement
func take_damage(damage : float, source : Node2D, _delta):
	assert(false, 'override take_damage()')


func get_stunned(duration):
	stunTimer.wait_time = duration
	stunTimer.start()


func get_speed():
	if stunTimer.is_stopped():
		return SPEED
	elif !stunTimer.is_stopped():
		return 0


func knockback(knockback_amount, direction):
	get_stunned(4)
	velocity = direction * knockback_amount
	move_and_slide()

extends "res://LivingEntity.gd"

enum states {
	WANDERING,
	CHASING
}

const DAMAGE = 15

@onready var crumb_fact = preload("res://environment/PlayerBreadcrumb.tscn")
@onready var wanderTimer : Timer = $WanderTimer
@onready var navAgent : NavigationAgent2D = $NavigationAgent2D

var health = 2

var current_target : Node2D = null
var target_is_player : bool = false
var wander_direction : Vector2 = Vector2(0,0)
var currentState = states.WANDERING
var target_distance : float = 0.0
var target_distance_delta : float = 0.0

func _ready():
	SPEED = 4.3

	%Slime.play_walk()
	current_target = null
	wander_direction = random_vector()


func _physics_process(_delta):
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = null
	
	if currentState == states.CHASING:
		navAgent.target_position = current_target.global_position
		var nextPos = navAgent.get_next_path_position()
		
		direction = global_position.direction_to(nextPos)
	elif currentState == states.WANDERING:
		var testTransform = Transform2D(Vector2(wander_direction.x,0),Vector2(0,wander_direction.y),global_position)
		if test_move(testTransform, wander_direction):
			wander_direction = random_vector()
		# slower when wandering
		direction = wander_direction * 0.3
		
	velocity = direction * get_speed()
	
	move_and_collide(velocity)


func take_damage(damage, source, _delta):
	%Slime.play_hurt()
	health -= damage
	
	if current_target == null || !target_is_player:
		current_target = source
		target_distance = global_position.distance_to(current_target.global_position)
		target_is_player = true
		alert()
	
	if health <= 0:
		const SMOKE_FACT = preload("res://assets/smoke_explosion/smoke_explosion.tscn")
		var smoke = SMOKE_FACT.instantiate()
		smoke.global_position = global_position
		get_parent().add_child(smoke)
		queue_free()


func get_damage():
	return DAMAGE


func knockback(knockback_amount, direction):	
	velocity = direction * knockback_amount
	move_and_slide()


func _on_wander_timer_timeout():
	if current_target != null:
		var new_target_distance = global_position.distance_to(current_target.global_position)
		target_distance_delta = new_target_distance - target_distance
	
	wander_direction = random_vector()
	wanderTimer.wait_time = randf_range(0.75,1.25)
	wanderTimer.start()


func random_vector():
	var randx = randi_range(-10, 10)
	var randy = randi_range(-10, 10)
	return global_position.direction_to(Vector2(global_position.x + randx, global_position.y + randy))


func _on_sight_range_area_entered(area):
	if currentState == states.WANDERING:
		if area.is_in_group('PlayerArea'):
			print_debug('player')
			current_target = area
			target_distance = global_position.distance_to(current_target.global_position)
			target_is_player = true
			print_debug('Get the player!')
			alert()
		elif area.is_in_group('Breadcrumbs'):
			print_debug('breadcrumb')
			current_target = area.next()
			target_distance = global_position.distance_to(current_target.global_position)
			print_debug('Hmm, footprints...')
			alert()
	
	if currentState == states.CHASING && !target_is_player:
		if area.is_in_group('PlayerArea'):
			current_target = area
			target_distance = global_position.distance_to(current_target.global_position)
			target_is_player = true
			print_debug('Finally caught you!')
			alert()
		elif area.is_in_group('Breadcrumbs'):
			current_target = area.next()
			target_distance = global_position.distance_to(current_target.global_position)

# rewrite to set neighbor slimes' current_target to the offending player
# problem here, can't create area2d instances during a signal call
func alert():
	currentState = states.CHASING
	var new_crumb = crumb_fact.instantiate()
	new_crumb.global_position = global_position
	new_crumb.link(current_target)
	get_parent().add_child(new_crumb)


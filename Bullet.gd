extends Area2D

# who threw this?
var SOURCE := CharacterBody2D

# Default parameters which can be adjusted based on calling weapon
var SPEED = 1000
var MAX_RANGE = 2000
var DAMAGE = 1;
var KNOCKBACK = 1000
var pierce_remaining = 0

# tracking variable for removing old projectiles
var travelled_distance = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var direction = Vector2.RIGHT.rotated(rotation)
	
	position += direction * SPEED * delta
	travelled_distance += SPEED * delta
	
	if travelled_distance >= MAX_RANGE:
		queue_free()


func _on_body_entered(body):
	if body is TileMap:
		queue_free()
		
	if body.has_method("take_damage"):
		body.take_damage(DAMAGE, SOURCE, 1)
		
		var direction = Vector2.RIGHT.rotated(rotation)
		body.knockback(KNOCKBACK, direction)
		
		pierce_remaining -= 1
	
	if pierce_remaining < 0:
		queue_free()

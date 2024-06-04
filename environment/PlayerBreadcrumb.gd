extends Area2D

# they tell on the players
var next_breadcrumb = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
# called when the next breadcrumb is created. Better name pending
func link(new_crumb):
	next_breadcrumb = new_crumb

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

# When breadbrumb is stale, delete it
func _on_timer_timeout():
	queue_free()
	
func next():
	return next_breadcrumb

extends Area2D

# valid values are:
# PRIMARY_WEAPON
# SECONDARY_WEAPON
# THROWABLE
# MAJOR_SUPPORT
# MINOR_SUPPORT
var type : String = 'DEFAULT'

enum state {
	CARRIED,
	EQUIPPED,
	ONGROUND
}

# default pickup state is on ground
var currentState = state.ONGROUND

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	

# Default pickup item behavior, just delete it. Oh, and throw an error.
# Override this
func interact(calling_player):
	assert(false, 'override my interact') 
	queue_free()


func get_type():
	return type


func setCarried():
	currentState = state.CARRIED


func set_equipped():
	currentState = state.EQUIPPED


func _on_body_entered(body):
	if body.is_in_group('Players') && currentState == state.ONGROUND:
		print_debug('Player entered activation area')
		body.add_interactible(self)


func _on_body_exited(body):
	if body.is_in_group('Players') && currentState == state.ONGROUND:
		print_debug('Player exited activation area')
		body.remove_interactible(self)

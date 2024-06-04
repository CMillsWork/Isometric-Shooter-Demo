extends "res://equipment/PickupItem.gd"

@onready var myFactory = "res://equipment/healing_potion.tscn"
var spritePath = "res://assets/tile159.png"

# Called when the node enters the scene tree for the first time.
func _ready():
	type = 'MINOR_SUPPORT'
	pass # Replace with function body.


# Called every fsrame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if get_parent().is_in_group('Players') && currentState == state.EQUIPPED:
		global_position = get_parent().global_position
		if Input.is_action_pressed('shoot'):
			print_debug('using potion')
			use()
		

func get_sprite():
	return %PotionSprite


# Should only be able to be picked up once
func interact(calling_player):
	if currentState == state.ONGROUND:
		calling_player.pickUp(myFactory, type)
		queue_free()

func use():
	print_debug('using healing potion')
	get_parent().heal_damage(30)
	get_parent().remove(type)
	queue_free()

extends "res://equipment/PickupItem.gd"

const NAME : String = "CROSSBOW"

var canFire : bool = false
var myFactory = "res://equipment/weapons/crossbow.tscn"
@onready var sprite = $WeaponPivot/CrossbowSprite


# Called when the node enters the scene tree for the first time.
func _ready():
	print_debug('readying crossbow')
	type = 'PRIMARY_WEAPON'
	var timer = %Timer
	timer.start()
	print_debug(%Timer.time_left)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	print_debug(%Timer.time_left)
	if currentState == state.EQUIPPED:
		var sprite = %CrossbowSprite

		var mouse_pos = get_global_mouse_position()
		look_at(mouse_pos)
		
		if(Input.is_action_pressed('shoot') && canFire):
			shoot()

func shoot():
	%CrossbowSprite.play('fire')
	const BULLET_FACTORY = preload("res://bullet.tscn")
	var bullet = BULLET_FACTORY.instantiate()
	bullet.SOURCE = get_parent()
	
	bullet.global_position = %Muzzle.global_position
	bullet.global_rotation = %Muzzle.global_rotation
	
	%Muzzle.add_child(bullet)
	
	canFire = false
	var timer = %Timer
	timer.start()


func get_type():
	return type


func _on_timer_timeout():
	print_debug('Ready to fire!')
	canFire = true


# Weapons can be picked up many times
func interact(calling_player):
	print_debug('I\'m being interacted with!')
	if currentState == state.ONGROUND:
		calling_player.pickUp(myFactory, type)

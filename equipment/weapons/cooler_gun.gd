extends "res://equipment/PickupItem.gd"

const NAME : String = "COOLER GUN"

var canFire : bool = false
var myFactory = "res://equipment/weapons/cooler_gun.tscn"
@onready var sprite = $WeaponPivot/Pistol


# Called when the node enters the scene tree for the first time.
func _ready():
	type = 'PRIMARY_WEAPON'
	var timer = $Timer
	timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if get_parent().is_in_group('Players') && currentState == state.EQUIPPED:
		var mouse_pos = get_global_mouse_position()
		look_at(mouse_pos)
	
		if global_position.x > mouse_pos.x:
			sprite.flip_v = 1
		else:
			sprite.flip_v = 0
	
		if(Input.is_action_pressed('shoot') && canFire):
			shoot()
		
func shoot():
	# todo: send signal to shake screen
	const BULLET_FACTORY = preload("res://bullet.tscn")
	var bullet = BULLET_FACTORY.instantiate()
	
	bullet.pierce_remaining = 4
	bullet.DAMAGE = 3
	bullet.scale = Vector2(1.5,1.5)
	bullet.SOURCE = get_parent()
	
	var muzzle_pos = %Muzzle.global_position
	
	bullet.global_position = %Muzzle.global_position
	bullet.global_rotation = %Muzzle.global_rotation
	
	%Muzzle.add_child(bullet)
	
	canFire = false
	var timer = $Timer
	timer.start()


func get_type():
	return type


func _on_timer_timeout():
	canFire = true


# Weapons can be picked up many times
func interact(calling_player):
	print_debug('I\'m being interacted with!')
	if currentState == state.ONGROUND:
		calling_player.pickUp(myFactory, type)

extends "res://equipment/PickupItem.gd"

const NAME : String = "GUN"

var canFire = false

# Called when the node enters the scene tree for the first time.
func _ready():
	type = 'SECONDARY_WEAPON'
	var timer = $Timer
	timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if currentState == state.EQUIPPED:
		var mouse_pos = get_global_mouse_position()
		var sprite = $Pistol

		look_at(get_global_mouse_position())
		
		if global_position.x > mouse_pos.x:
			sprite.flip_v = 1
		else:
			sprite.flip_v = 0
		
		if(Input.is_action_pressed('shoot') && canFire):
			shoot()
		
func shoot():
	const BULLET_FACTORY = preload("res://bullet.tscn")
	var bullet = BULLET_FACTORY.instantiate()
	bullet.SOURCE = get_parent()
	
	var muzzle_pos = %Muzzle.global_position
	
	bullet.global_position = %Muzzle.global_position
	bullet.global_rotation = %Muzzle.global_rotation
	
	%Muzzle.add_child(bullet)
	
	get_parent().add_trauma(10)
	
	canFire = false
	var timer = $Timer
	timer.start()


func get_type():
	return type


func _on_timer_timeout():
	canFire = true

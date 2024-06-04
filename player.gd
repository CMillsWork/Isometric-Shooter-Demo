extends "res://LivingEntity.gd"

const PRIMARY_WEAPON = 'PRIMARY_WEAPON'
const SECONDARY_WEAPON = 'SECONDARY_WEAPON'
const THROWABLE = 'THROWABLE'
const MAJOR_SUPPORT = 'MAJOR_SUPPORT'
const MINOR_SUPPORT = 'MINOR_SUPPORT'

const JUMP_VELOCITY = -400.0

var primary = null
var secondary = null
var throwable = null
var major_support = null
var minor_support = null

var primary_sprite = null
var secondary_sprite = null
var throwable_sprite = null
var major_support_sprite = null
var minor_support_sprite = null

var currently_equipped = null

var nearby_objects = []

signal health_depleted

var health = 100.0

func _ready():
	SPEED = 300.0

	secondary = 'res://equipment/weapons/gun.tscn'
	pickUp(secondary, SECONDARY_WEAPON)
	currently_equipped = secondary.instantiate()
	currently_equipped.set_equipped()
	add_child(currently_equipped)
	handle_inventory_visibility()
	
	#primary = preload("res://equipment/weapons/cooler_gun.tscn")

func _physics_process(delta):
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	velocity = direction * get_speed()

	move_and_slide()
	
	#handle animations
	if velocity.length() > 0:
		$HappyBoo.play_walk_animation()
	else:
		$HappyBoo.play_idle_animation()
		
	# handle collision damage
	# todo: abstract out to handle mobs/projectiles with different damage
	var overlapping_mobs = %HurtBox.get_overlapping_bodies()
	if overlapping_mobs.size() > 0:
		var inc_damage = 0
		
		# todo: move into take_damage() method
		for mob in overlapping_mobs:
			take_damage(mob.get_damage(), mob, delta)
	
		# sort nearby interactibles to always target closest
		nearby_objects.sort_custom(func(a,b): return global_position.distance_to(a.global_position) > global_position.distance_to(b.global_position))


# non-move inputs
func _input(event):
	if event.is_action_pressed('equip_primary'):
		if (currently_equipped == null || currently_equipped.get_type() != 'PRIMARY_WEAPON')  && primary != null:
			remove_child(currently_equipped)
			# todo: move these four lines into new method
			currently_equipped = primary.instantiate()
			currently_equipped.set_equipped()
			add_child(currently_equipped)
			handle_inventory_visibility()
			
	if event.is_action_pressed('equip_secondary'):
		if (currently_equipped == null || currently_equipped.get_type() != 'SECONDARY_WEAPON')  && secondary != null:
			remove_child(currently_equipped)
			currently_equipped = secondary.instantiate()
			currently_equipped.set_equipped()
			add_child(currently_equipped)
			handle_inventory_visibility()
			
	if event.is_action_pressed('equip_throwable'):
		if (currently_equipped == null || currently_equipped.get_type() != 'THROWABLE')  && throwable != null:
			remove_child(currently_equipped)
			currently_equipped = throwable.instantiate()
			currently_equipped.set_equipped()
			add_child(currently_equipped)
			handle_inventory_visibility()
			
	if event.is_action_pressed('equip_major_support'):
		if (currently_equipped == null || currently_equipped.get_type() != 'MAJOR_SUPPORT') && major_support != null:
			remove_child(currently_equipped)
			currently_equipped = major_support.instantiate()
			currently_equipped.set_equipped()
			add_child(currently_equipped)
			handle_inventory_visibility()
			
	if event.is_action_pressed('equip_minor_support'):
		if (currently_equipped == null || currently_equipped.get_type() != 'MINOR_SUPPORT') && minor_support != null:
			remove_child(currently_equipped)
			currently_equipped = minor_support.instantiate()
			currently_equipped.set_equipped()
			add_child(currently_equipped)
			handle_inventory_visibility()
			
	if event.is_action_pressed('interact'):
		if nearby_objects.size() > 0:
			nearby_objects[0].interact(self)


# todo: rename to 'carry' or something; also, implement throwable an major_support
func pickUp(itemFactory, type):
	match type:
		PRIMARY_WEAPON:
			primary = load(itemFactory)
			primary_sprite = primary.instantiate()
			primary_sprite.set_global_rotation_degrees(-15)
			primary_sprite.scale = Vector2(0.5,0.5)
			primary_sprite.setCarried()
			%PrimarySlot.add_child(primary_sprite)
		SECONDARY_WEAPON:
			secondary = load(itemFactory)
			secondary_sprite = secondary.instantiate()
			secondary_sprite.set_global_rotation_degrees(-15)
			secondary_sprite.scale = Vector2(0.5,0.5)
			secondary_sprite.setCarried()
			%SecondarySlot.add_child(secondary_sprite)
		MINOR_SUPPORT:
			minor_support = load(itemFactory)
			minor_support_sprite = minor_support.instantiate()
			minor_support_sprite.set_global_rotation_degrees(-15)
			minor_support_sprite.scale = Vector2(0.5,0.5)
			minor_support_sprite.setCarried()
			%MinorSupportSlot.add_child(minor_support_sprite)


func remove(type):
	print_debug('removing an item from inventory')
	match type:
		'MINOR_SUPPORT':
			print_debug('removing a minor support item')
			minor_support_sprite = null
			minor_support = null
			currently_equipped = null


func get_health():
	return health


func take_damage(damage, source, _delta):
	# todo: implement %HappyBoo.play_hurt()
	
	health -= damage * _delta
	%HealthBar.value = health
	if health <= 0:
		health_depleted.emit()
		
	# todo: implement KO'd PC animation


# params:
#	heal_amount - amount to heal the player
#	(not implemented) hot_time	- if a heal over time effect, number of ticks over which the healing occurs
func heal_damage(heal_amount):
	health += heal_amount
	
	if health > 100:
		health = 100
		
	%HealthBar.value = health


func add_interactible(newObject):
	nearby_objects.append(newObject)


func remove_interactible(oldObject):
	nearby_objects.erase(oldObject)

# After changing equipment, let's make sure equipment are still appropriately visualized
func handle_inventory_visibility():
	if currently_equipped.get_type() == PRIMARY_WEAPON:
		%PrimarySlot.visible = false
	elif currently_equipped.get_type() == SECONDARY_WEAPON:
		%SecondarySlot.visible = false
	elif currently_equipped.get_type() == THROWABLE:
		%ThrowableSlot.visible = false
	elif currently_equipped.get_type() == MAJOR_SUPPORT:
		%MajorSupportSlot.visible = false
	elif currently_equipped.get_type() == MINOR_SUPPORT:
		%MinorSupportSlot.visible = false
	
	if currently_equipped.get_type() != PRIMARY_WEAPON:
		%PrimarySlot.visible = true
	if currently_equipped.get_type() != SECONDARY_WEAPON:
		%SecondarySlot.visible = true
	if currently_equipped.get_type() != THROWABLE:
		%ThrowableSlot.visible = true
	if currently_equipped.get_type() != MAJOR_SUPPORT:
		%MajorSupportSlot.visible = true
	if currently_equipped.get_type() != MINOR_SUPPORT:
		%MinorSupportSlot.visible = true


func add_trauma(trauma : float):
	%Camera.apply_shake(trauma)


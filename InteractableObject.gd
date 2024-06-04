@tool
extends Area2D
class_name InteractableObject

enum objectTypes {
	PICKUP, # weapon, equipment, etc
	CARRY,	# large object taking up both hands
	USABLE	# a crank, door, cart to push, etc
}

@export_group('ObjectProperties')
@export var type : objectTypes = objectTypes.PICKUP

var data_object : Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func setup(newDataObject, newType, usetime : int = 10) -> void:
	type = newType
	data_object = newDataObject

# When a player enters the area, tell that player they can interact with this
func _on_area_entered(area) -> void:
	var player = area.get_parent()
	
	if player.has_method('add_interactable'):
		player.add_interactable(self)

# When a player enters the area, tell that player they can no longer use this
func _on_area_exited(area) -> void:
	var player = area.get_parent()
	
	if player.has_method('remove_interactable'):
		player.remove_interactable(self)

func use():
	assert(false, 'Please implement a use() method for this node!')

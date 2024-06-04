extends Area2D
# Rooms are used to delineate sections of levels.
# Rooms contain spawn_zone nodes and supply_zone nodes
# Room nodes receive calls to spawn mobs periodically from the game_controller

var spawn_nodes = []
var supply_nodes = []
var rally_point
var players_in_room : int = 0
var active : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	for child in get_children(false):
		if child.is_in_group('EnemySpawnNodes'):
			spawn_nodes.append(child)
		elif child.is_in_group('SupplyNodes'):
			supply_nodes.append(child)
		elif child.is_in_group('RallyPoints'):
			rally_point = child

# Populates child supply_zones based on input from the director 
# params:
# 	director_value - integer value used to track the current state of the players
func populate_supplies(director_value):
	for node in supply_nodes:
		node.populate_supplies(director_value)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):	
	if body.is_in_group('Players') :
		players_in_room += 1
		active = true

func _on_body_shape_exited(body_rid, body, body_shape_index, local_shape_index):
	if body.is_in_group('Players') :
		players_in_room -= 1
		
	if players_in_room == 0:
		active = false
		
func is_active():
	return active

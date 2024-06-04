extends Node2D

# stored here so we can always get back to it
@onready var main_menu = preload("res://main_menu.tscn")
@onready var crumb_factory = preload("res://environment/PlayerBreadcrumb.tscn")

var current_scene
var director_value  = 0
var time_since = 0

var players = []
var most_recent_crumbs = []

#for advanced loading, maybe not needed
var next_scene

# Called when the node enters the scene tree for the first time.
func _ready():
	current_scene = main_menu.instantiate()
	set_current_scene(current_scene)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	director_value = 0
	
	# update director_value
	var players = get_tree().get_nodes_in_group('Players')
	# add player health
	for player in players:
		director_value += player.get_health()
	
	# add value for player equipment
		# primary
		# secondary
		# throwable
		# minor support
		# major support
	# add value for progress in map, using room difficulty
		# current_scene.current_room.difficulty

# used for changing levels or returning to main menu
func set_current_scene(newScene):
	remove_child(current_scene)
	current_scene = newScene
	add_child(current_scene)
	
	players = []
	
	var children = current_scene.get_children()
	for child in children:
		if child.is_in_group('Players'):
			players.append(child)

func _on_spawn_timer_timeout():
	time_since = 0
	spawn_baddies()

func spawn_baddies():
	# get a spawn node
	if current_scene.has_method('spawn_mobs'):
		var mobs_to_spawn = (director_value - 50)/5
		var elites_to_spawn = (director_value - 100)/20
		var bosses_to_spawn = (director_value - 200)/50
		
		current_scene.spawn_mobs(mobs_to_spawn, elites_to_spawn, bosses_to_spawn)

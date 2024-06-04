extends Node2D

@onready var common_mob = preload("res://mobs/slime.tscn")

var rooms = []

# Called when the node enters the scene tree for the first time.
func _ready():
	for child in get_children():
		if child.is_in_group('Rooms'):
			rooms.append(child)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	#connect("set_new_enemy_spawn", self, "")
	pass

func spawn_mobs(mobs_to_spawn, elites_to_spawn, bosses_to_spawn):
	
	for room in rooms:
		if room.is_active():
			for n in mobs_to_spawn:
				var mob = common_mob.instantiate()
				var spawn_node = room.spawn_nodes.pick_random()
				var temp_position = spawn_node.global_position
				var size = spawn_node.get_children()[0].get_shape().get_rect().size
				var newPos = Vector2((randi() % int(size.x)) + temp_position.x, (randi() % int(size.y)) + temp_position.y)
				mob.global_position = newPos
				if room.rally_point != null:
					mob.current_target = room.rally_point
				add_child(mob)

func _on_player_health_depleted():
	%GameOverScreen.visible = true
	get_tree().paused = true

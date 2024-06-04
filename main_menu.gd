extends Node2D

@onready var level_1_1 = preload("res://level_1_1.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_menu_button_pressed():
	get_parent().set_current_scene(level_1_1.instantiate())

extends Node2D

var current_scene
@export var start_scene : PackedScene

func _ready():
	# connect scene change signal
	GlobalSignals.connect("change_scene", Callable(self, "go_to_new_scene"))
	# load the starting scene for the game
	var start = start_scene.instantiate()
	go_to_new_scene(start)

func go_to_new_scene(target_scene : Node2D):
	#load in the target scene
	self.add_child(target_scene)
	# remove the current scene if there is one
	if current_scene != null:
		self.remove_child(current_scene)
		current_scene.queue_free()
	# set the new scene to the current
	current_scene = target_scene

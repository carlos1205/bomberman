extends RigidBody2D

const seconds = .3
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	set_mode(RigidBody2D.MODE_STATIC)
	$Timer.start(seconds)
	
func time_out():
	$Timer.stop()
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

extends RigidBody2D
signal explosion

const seconds = 3
var player

func _ready():
	$AnimatedSprite.animation = "bombe"
	$Timer.start(seconds)

func get_radius():
	return $CollisionShape2D.shape.radius

func time_out():
	print("Time out!")
	$Timer.stop()
	explose()

func explose():
	emit_signal("explosion", position)
	queue_free()

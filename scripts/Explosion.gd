extends RigidBody2D

var seconds = 1

func _ready():
	$AnimatedSprite.animation = "init_explosion"
	$Timer.start(seconds)

func time_out():
	expand()

func expand():
	queue_free()

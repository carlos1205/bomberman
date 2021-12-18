extends KinematicBody2D
signal collided

var speed = 50
var direction = Vector2.ZERO

const BOMBE = "Bombe"
const EXPLOSION = "@Explosion"
const TILE = "TileMap"

func _ready():
	var random = RandomNumberGenerator.new()
	direction = Vector2(1,0)
	$AnimatedSprite.play()
	$AnimatedSprite.animation = "walk-vertical"

func random_direction(possible_direction):
	var selected_direction = possible_direction[ randi() % possible_direction.size()]
	return selected_direction

func _physics_process(delta):
	var velocity = Vector2.ZERO
	velocity = direction.normalized() * speed
	if velocity.x != 0:
		$AnimatedSprite.animation = "walk-vertical"
		$AnimatedSprite.flip_v = false
		$AnimatedSprite.flip_h = velocity.x < 0
	elif velocity.y > 0:
		$AnimatedSprite.animation = "walk-front"
	elif velocity.y < 0:
		$AnimatedSprite.animation = "walk-back"
	else:
		if "walk-down" == $AnimatedSprite.animation:
			$AnimatedSprite.animation = "still-up"
		elif "walk-up" == $AnimatedSprite.animation:
			$AnimatedSprite.animation = "still-down"
		elif "walk-vertical" == $AnimatedSprite.animation:
			$AnimatedSprite.animation = "still-vertical"
	move_and_slide(velocity)
	is_colliding()

func is_colliding():
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if collision:
			if(collision.collider.name == TILE):
				speed = 0
				$CollisionShape2D.disabled = true
				emit_signal('collided', position, self)
				
			if(EXPLOSION.is_subsequence_ofi(collision.collider.name)):
				$CollisionShape2D.disabled = true
				dead()

func turn_of(orientations):
	direction = random_direction(orientations)
	speed = 50
	$CollisionShape2D.disabled = false

func dead():
	queue_free()

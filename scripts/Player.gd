extends KinematicBody2D
signal plant_bombe

export var speed = 200
var screen_size
var bombes
var planted
var canPassBombe

const BOMBE = "Bombe"
const EXPLOSION = "Explosion"

func _ready():
	screen_size = get_viewport_rect().size
	hide()

func _input(event):
	if event.is_action_pressed("plant"):
		plantBombe()

func start(pos):
	position = pos
	bombes = 1
	planted = 0
	$AnimatedSprite.animation = "still-front"
	show()
	$CollisionShape2D.disabled = false
	
func collision(body):
	if EXPLOSION == body.name:
		$CollisionShape2D.set_deferred("disabled", true)
		dead()
	
	if BOMBE == body.name and !canPassBombe:
		var pos = body.position
		if pos.x < position.x:
			position.x += 15
		if pos.x > position.x:
			position.x -= 15
		if pos.y < position.y:
			position.y += 15
		if pos.y > position.y:
			position.y -= 15

func _on_Player_body_exited(body):
	canPassBombe = false

func plantBombe():
	if(planted < bombes):
		planted += 1
		emit_signal("plant_bombe", position)
		canPassBombe = true

func getInput(delta, velocity):
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()
	return velocity

func _physics_process(delta):
	var velocity = Vector2()
	velocity = getInput(delta, velocity)
	velocity = move_and_slide(velocity, Vector2(0,-1))
	if velocity.x != 0:
		$AnimatedSprite.animation = "walk-side"
		$AnimatedSprite.flip_v = false
		$AnimatedSprite.flip_h = velocity.x < 0
	elif velocity.y > 0:
		$AnimatedSprite.animation = "walk-front"
	elif velocity.y < 0:
		$AnimatedSprite.animation = "walk-back"
	else:
		if "walk-back" == $AnimatedSprite.animation:
			$AnimatedSprite.animation = "still-back"
		elif "walk-front" == $AnimatedSprite.animation:
			$AnimatedSprite.animation = "still-front"
		elif "walk-side" == $AnimatedSprite.animation:
			$AnimatedSprite.animation = "still-side"
	is_colliding()

func is_colliding():
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if collision:
			emit_signal('collided', collision)

func dead():
	queue_free()

extends Area2D
signal hit
signal plant_bombe

export var speed = 400
var screen_size
var bombes
var planted
var canPassBombe

const BOMBE = "Bombe"

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
	show()
	$CollisionShape2D.disabled = false

func collision(body):
	if BOMBE == body.name and !canPassBombe:
		var pos = body.position
		var velocity = Vector2()
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

func _process(delta):
	var velocity = Vector2()
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
	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
	
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

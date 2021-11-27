extends Area2D
signal hit
signal plant_bombe

export var speed = 400
var screen_size

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	hide()

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

func _input(event):
	if event.is_action_pressed("plant"):
		plantBombe()

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = true

func _on_Area2D_body_entered(body):
	hide()
	emit_signal("hit")
	$CollisionShape2D.set_deferred("disable", true)

func plantBombe():
	emit_signal("plant_bombe", position)

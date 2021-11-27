extends Node

export (PackedScene) var Bombe 

func _ready():
	new_game()

func new_game():
	$Player.start($StartPosition.position)

func bombe_insert(pos):
	var bombe = Bombe.instance()
	print_debug(bombe)
	add_child(bombe)
	bombe.position = pos

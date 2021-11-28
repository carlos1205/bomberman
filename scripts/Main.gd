extends Node

export (PackedScene) var Bombe
export (PackedScene) var Player
export (PackedScene) var Explosion

var player
func _ready():
	new_game()

func new_game():
	player = pre_configure_game()
	add_child(player)
	player.connect("plant_bombe", self, "bombe_insert")
	player.start($StartPosition.position)

func bombe_insert(pos):
	var bombe = Bombe.instance()
	add_child(bombe)
	bombe.position = pos
	bombe.connect("explosion", self, "bombe_finish")

func pre_configure_game():
	var selfPeerId = get_tree().get_network_unique_id()
	
	var myPlayer = Player.instance()
	myPlayer.set_name("my_player")
	return myPlayer

func bombe_finish(pos):
	var explosion = Explosion.instance()
	add_child(explosion)
	explosion.position = pos
	player.planted -= 1

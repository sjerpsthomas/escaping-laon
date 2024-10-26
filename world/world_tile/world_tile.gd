class_name WorldTile
extends Node2D


@onready var player := $Player as Player

@onready var world := get_parent().get_parent() as World

var coords: Vector2i


# -
func _ready() -> void:
	# HACK: y sort not saved properly
	y_sort_enabled = true

# 
func generate_walls(tile: WorldGenerator.Tile) -> void:
	var walls := WorldGenerator.Tile.all_directions
	
	# go over all walls
	for i in range(walls.size()):
		var wall = walls[i]
		
		if wall not in tile.walls:
			# free wall at index if not in tile
			$Walls.get_child(i).queue_free()
		else:
			# free arrow at index if wall in tile
			$Arrows.get_child(i).queue_free()

# (ABSTRACT) generates content for the tile
func generate() -> void: pass

# generates zombies
func generate_zombies(count: int) -> void:
	var zombie_scene := preload("res://zombie/zombie.tscn")
	
	for i in count:
		var pos := Vector2(randf_range(-38, 38), randf_range(-38, 38))
		var zombie: Zombie = zombie_scene.instantiate()
		zombie.name = "Zombie" + str(i)
		add_child(zombie)
		zombie.position = pos

# generates coins
func generate_coins(count: int) -> void:
	var coin_scene := preload("res://coin/coin.tscn")
	
	for i in count:
		var pos := Vector2(randf_range(-38, 38), randf_range(-38, 38))
		var coin: Node2D = coin_scene.instantiate()
		coin.name = "Coin" + str(i)
		add_child(coin)
		coin.position = pos

# navigates the world in the specified direction
func go(direction: int) -> void:
	print(direction)

class_name World
extends Node2D


@export var size: Vector2i
@export var start_coords: Vector2i

@onready var camera := $Camera as Camera2D

var tiles: Array[WorldTile]
var current_coords: Vector2i


# -
func _ready() -> void:
	tiles.resize(size.x * size.y)
	
	WorldGenerator.width = size.x
	WorldGenerator.height = size.y
	WorldGenerator.generate(0)
	
	generate_tiles()
	assert(size.x * size.y == $Tiles.get_child_count())
	
	# set coords
	set_current_coords(start_coords, false)

# creates all tile scenes
func generate_tiles() -> void:
	tiles.resize(size.x * size.y)
	var tile_scene := preload("res://world/world_tile/types/zombie_small_group.tscn")
	for y in range(size.y):
		for x in range(size.x):
			var new_tile := tile_scene.instantiate() as WorldTile
			place_tile(Vector2i(x, y), new_tile)

# places a tile in the world
func place_tile(coords: Vector2i, tile: WorldTile) -> void:
	# set coords
	tile.coords = coords
	set_tile(coords, tile)
	
	$Tiles.add_child(tile)
	
	# set position
	tile.position = Vector2(48, 48) + Vector2(coords * 96)
	
	# generate walls
	tile.generate_walls(WorldGenerator.get_tile(coords))
	
	# generate tile-specific attributes
	tile.generate()

# sets the tile at the specified coords
func set_tile(coords: Vector2i, tile: WorldTile) -> void:
	tiles[coords.x + size.x * coords.y] = tile

# gets the tile at the specified coords
func get_tile(coords: Vector2i) -> WorldTile:
	return tiles[coords.x + size.y * coords.y]

# sets the current world coordinates
func set_current_coords(new_current_coords: Vector2i, place_player := true) -> void:
	# assert in range
	if new_current_coords.x < 0 or new_current_coords.x >= size.x: return
	if new_current_coords.y < 0 or new_current_coords.y >= size.y: return
	
	var prev_coords := current_coords
	current_coords = new_current_coords
	
	# move camera
	camera.coords = current_coords
	
	# (de-)activate tiles
	for tile in tiles:
		var active := tile.coords == current_coords
		tile.process_mode = Node.PROCESS_MODE_INHERIT if active else Node.PROCESS_MODE_DISABLED
		tile.player.visible = active
		
		# place player
		if active and place_player:
			var player := tile.player
			var direction := Vector2(prev_coords - current_coords).angle()
			player.position = 48 * Vector2.RIGHT.rotated(direction)

# moves the current coordinates by the direction
func move(direction_coords: Vector2i) -> void:
	set_current_coords(current_coords + direction_coords)

extends Node


var width: int
var height: int

var maze: Array[Tile]


# generates the maze
func generate(seed: int = randi()) -> void:
	seed(seed)
	
	# populate maze
	maze.clear()
	maze.resize(width * height)
	for i in range(width * height): maze[i] = Tile.new()
	
	# iterate through first tile
	iterate(Vector2i(0, 0))

# iterates maze generation at the specified coordinate
func iterate(pos: Vector2i) -> void:
	# get tile, set as visited
	var tile := get_tile(pos)
	tile.visited = true
	
	# randomize unvisited directions
	tile.walls.shuffle()
	
	# go through directions
	for direction in tile.walls:
		# get tile, check if present and visible
		var new_coords := pos + Tile.pos_to_add(direction)
		var new_tile := get_tile(new_coords)
		if new_tile == null or new_tile.visited: continue
		
		# remove walls
		tile.walls.erase(direction)
		new_tile.walls.erase(Tile.opposite_direction(direction))
		
		# iterate on new tile
		#  (effectively performing DFS)
		iterate(new_coords)

# gets the tile at the specified position
func get_tile(pos: Vector2i) -> Tile:
	# check bounds
	if pos.x < 0 or pos.x >= width or pos.y < 0 or pos.y >= height:
		return null
	
	# access maze
	return maze[pos.x + width * pos.y]


# (a maze tile)
class Tile:
	var walls: Array[Direction]
	var visited: bool
	
	# -
	func _init() -> void:
		walls.assign(all_directions)
		visited = false
	
	# (a direction in the maze)
	enum Direction {LEFT, RIGHT, UP, DOWN}
	static var all_directions := [Direction.LEFT, Direction.RIGHT, Direction.UP, Direction.DOWN]
	
	# gets the opposite direction from the one specified
	static func opposite_direction(direction: Direction) -> Direction:
		match direction:
			Direction.LEFT: return Direction.RIGHT
			Direction.RIGHT: return Direction.LEFT
			Direction.UP: return Direction.DOWN
			Direction.DOWN: return Direction.UP
			_: assert(false); return -1
	
	# gets the relative position from a direction
	static func pos_to_add(direction: Direction) -> Vector2i:
		match direction:
			Tile.Direction.LEFT: return Vector2i(-1, 0)
			Tile.Direction.RIGHT: return Vector2i(1, 0)
			Tile.Direction.UP: return Vector2i(0, -1)
			Tile.Direction.DOWN: return Vector2i(0, 1)
			_: assert(false); return Vector2i.ZERO

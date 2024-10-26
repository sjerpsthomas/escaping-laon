extends WorldTile


# (OVERRIDE) generates content for the tile
func generate() -> void:
	generate_zombies(randi_range(1, 3))
	generate_coins(randi_range(0, 5))

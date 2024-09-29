extends WorldTile


# (OVERRIDE) generates content for the tile
func generate() -> void:
	var zombie_scene := preload("res://zombie/zombie.tscn")
	var count := randi_range(1, 3)
	
	for i in count:
		var pos := Vector2(randf_range(-38, 38), randf_range(-38, 38))
		var zombie: Zombie = zombie_scene.instantiate()
		zombie.name = "Zombie" + str(i)
		add_child(zombie)
		zombie.position = pos

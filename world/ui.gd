extends Control


@onready var world := get_parent() as World


# -
func _process(_delta: float) -> void:
	position = world.camera.position - Vector2(72, 48)
	
	# move minimap
	$Minimap/Dot.position = world.current_coords * 2

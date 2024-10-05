extends Control


@onready var world := get_parent() as World

func _process(delta: float) -> void:
	position = world.camera.position - Vector2(72, 48)
	
	$Minimap/Dot.position = world.current_coords * 2

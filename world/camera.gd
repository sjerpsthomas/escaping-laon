extends Camera2D


var coords: Vector2i
var draw_coords: Vector2

var transition_offsets := {
	Vector2i.LEFT: 0,
	Vector2i.RIGHT: 0,
	Vector2i.UP: 0,
	Vector2i.DOWN: 0,
}

# -
func _process(_delta: float) -> void:
	var transition_offset := Vector2()
	for v: Vector2i in transition_offsets: transition_offset += Vector2(v) * transition_offsets[v]
	
	draw_coords = draw_coords.lerp(Vector2(coords), 0.15)
	
	position = Vector2(48, 48) + 96 * draw_coords + transition_offset
	position = position.round()

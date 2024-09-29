extends Sprite2D


@onready var world_tile := get_parent().get_parent() as WorldTile

@onready var direction := get_direction()

var go_timer := 0.0


# -
func _ready() -> void:
	# check if the arrow can be deleted
	await world_tile.ready
	await world_tile.world.ready
	var size := world_tile.world.size
	var coords_to := world_tile.coords + direction
	
	var valid := coords_to.x >= 0 and coords_to.y >= 0 \
		and coords_to.x < size.x and coords_to.y < size.y
	
	if not valid: queue_free()

# -
func _process(delta: float) -> void:
	var camera := world_tile.world.camera
	camera.transition_offsets[direction] = go_timer * 3
	
	var mouse_pos := get_local_mouse_position() - camera.offset
	
	var player: Player = world_tile.player
	var dist := global_position.distance_to(player.global_position)
	
	if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) or not Rect2(Vector2(-6, -6), Vector2(12, 12)).has_point(mouse_pos) or dist > 10:
		go_timer /= 1.1
		return
	
	go_timer += delta / 0.5
	
	if go_timer > 1:
		go_timer = 0
		camera.transition_offsets[direction] = 0
		world_tile.world.move(direction)
		camera.offset = Vector2()


func get_direction() -> Vector2i:
	var rot = roundi(rotation_degrees)
	
	# get coordinates to add
	match rot:
		0: return Vector2i.RIGHT
		270: return Vector2i.UP
		180: return Vector2i.LEFT
		90: return Vector2i.DOWN
		_: assert(false); return Vector2i.ZERO

class_name Player
extends Node2D


@onready var world_tile := get_parent() as WorldTile

@onready var sprite := $Sprite as Sprite2D


# -
func _process(delta: float) -> void:
	# move
	var prev_x := global_position.x
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		var mouse_pos := get_global_mouse_position().round()
		global_position = global_position.move_toward(mouse_pos, delta * 30)
	
	# flip sprite
	if roundi(prev_x) != roundi(global_position.x):
		sprite.scale.x = -1 if prev_x > global_position.x else 1

# attacks a zombie
func attack(zombie: Zombie) -> void:
	var dist := zombie.global_position.distance_to(global_position)
	
	if dist < 10:
		zombie.damage(0.4)

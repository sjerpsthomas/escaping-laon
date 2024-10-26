class_name Player
extends CharacterBody2D


@onready var world_tile := get_parent() as WorldTile

@onready var sprite := $Sprite as Sprite2D


# -
func _process(delta: float) -> void:
	# move
	var prev_x := global_position.x
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		var mouse_pos := get_global_mouse_position().round()
		velocity = 30 * (mouse_pos - global_position).normalized()
	
	# move, clamp position
	move_and_slide()
	position = position.clamp(Vector2(-46, -46), Vector2(46, 46))
	
	# reset velocity
	velocity = Vector2()
	
	# flip sprite
	if roundi(prev_x) != roundi(global_position.x):
		sprite.scale.x = -1 if prev_x > global_position.x else 1

# attacks a zombie
func attack(zombie: Zombie) -> void:
	$SwordCentre.scale.y *= -1
	$SwordCentre.rotation = global_position.angle_to_point(zombie.global_position)
	$AnimationPlayer.play("hit")
	
	var dist := zombie.global_position.distance_to(global_position)
	
	if dist < 10:
		zombie.damage(0.4)

class_name Zombie
extends CharacterBody2D


enum State { IDLE, ATTACK }


var dist_timer := 0.0

@onready var sprite := $Sprite as Sprite2D

@onready var world_tile := get_parent() as WorldTile

var state := State.IDLE
var health := 1.0

var idle_timer := 0.0
var attack_timer := 0.0

var follow_velocity: Vector2
var knockback_velocity: Vector2

# -
func _process(delta: float) -> void:
	handle_state(delta)

# switches the state of the zombie
func handle_state(delta: float) -> void:
	# get distance
	var player := world_tile.player
	var dist = global_position.distance_to(player.global_position)
	if dist < 24: dist_timer = minf(dist_timer + delta, 2)
	else: dist_timer = maxf(dist_timer - delta, 0)
	
	var new_state := State.IDLE if dist_timer < 0.5 else State.ATTACK
	
	if new_state != state:
		if new_state == State.IDLE: init_idle()
		else: init_attack()
	
	state = new_state
	
	# do stuff
	if state == State.IDLE: do_idle(delta)
	else: do_attack(delta)
	
	# move, dampen movement, clamp position
	velocity = follow_velocity + knockback_velocity
	move_and_slide()
	position = position.clamp(Vector2(-46, -46), Vector2(46, 46))
	
	# dampen knockback, reset follow velocity
	knockback_velocity = knockback_velocity * exp(-10 * delta)
	follow_velocity = Vector2()

# initializes idle state
func init_idle() -> void:
	idle_timer = randf_range(1, 2)

# processes idle state
func do_idle(delta: float) -> void:
	idle_timer -= delta
	if idle_timer <= 0:
		sprite.flip_h = not sprite.flip_h
		idle_timer = randf_range(1, 2)

# initializes attack state
func init_attack() -> void:
	pass

# processes attack state
func do_attack(delta: float) -> void:
	var player := world_tile.player
	var dist := global_position.distance_to(player.global_position)
	if dist < 6: return
	
	follow_velocity = 6 * (player.global_position - global_position).normalized()
	
	sprite.flip_h = follow_velocity.x < 1

# takes damage
func damage(amount: float) -> void:
	health -= amount
	
	knockback_velocity += (global_position - world_tile.player.global_position).normalized() * 70
	
	if health < 0:
		queue_free()

# handles clicking @ Area input_event
func _on_area_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("player_attack"):
		world_tile.player.attack(self)

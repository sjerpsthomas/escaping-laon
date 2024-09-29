class_name WorldTile
extends Node2D


@onready var player := $Player as Player

@onready var world := get_parent().get_parent() as World

var coords: Vector2i


# -
func _ready() -> void:
	# HACK: y sort not saved properly
	y_sort_enabled = true

# (ABSTRACT) generates content for the tile
func generate() -> void: pass

# navigates the world in the specified direction
func go(direction: int) -> void:
	print(direction)

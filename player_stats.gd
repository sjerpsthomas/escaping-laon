extends Node


var coins: int


# -
func _ready() -> void:
	load_stats()

# -
func _exit_tree() -> void:
	save_stats()

# load the stats
func load_stats() -> void:
	# open file for reading
	var file := FileAccess.open("user://stats.laon", FileAccess.READ)
	if file == null: return
	
	# get data
	coins = file.get_64()

# save the stats
func save_stats() -> void:
	# open file for writing
	var file := FileAccess.open("user://stats.laon", FileAccess.WRITE)
	if file == null: return
	
	# store data
	file.store_64(coins)

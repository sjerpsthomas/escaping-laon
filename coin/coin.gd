extends Node2D


# collects the coin @ Area body_entered
func _on_area_body_entered(body: Node2D) -> void:
	var player := body as Player
	if player == null: return
	
	queue_free()

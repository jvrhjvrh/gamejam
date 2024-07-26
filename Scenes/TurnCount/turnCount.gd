extends Label

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	text = "Turns: " + str(Turns.turns)

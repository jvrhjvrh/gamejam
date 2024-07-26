extends TextureRect

@export var parts: Array[HBoxContainer]
@export var arrows: Array[TextureRect]

func getRotation(pot: String) -> int:
	match pot:
		'potionU':
			return 0
		'potionD':
			return 180
		'potionR':
			return 90
		_:
			return 270

func _process(delta):
	for i in range(parts.size()):
		if Potion.potion.size() <= i:
			parts[i].visible = false
		else:
			var pot = Potion.potion[i]
			parts[i].visible = true
			var rotation: int = getRotation(pot)
			arrows[i].rotation_degrees = rotation

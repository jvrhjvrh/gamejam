extends TextureRect

enum Direction {
	right,
	left,
	up,
	down
}

@export var direction: Direction
@export var number: Resource
@export var label: Control
@export var numberTexture: TextureRect

func getRotation(value: Direction):
	match value:
		Direction.right:
			return 90
		Direction.left:
			return -90
		Direction.down:
			return 180
	return 0
		
func _ready():
	label.rotation_degrees = getRotation(direction)
	numberTexture.texture = number

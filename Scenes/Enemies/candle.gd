extends Area2D

const tileSize = 16
enum Direction  {
	Left,
	Right,
}

@onready var raycast: RayCast2D = $RayCast2D
@export var direction: Direction
@export var sprite: AnimatedSprite2D

func _ready():
	sprite.flip_h = direction == Direction.Right

func move():
	var dir: Vector2 = Vector2.RIGHT
	if direction == Direction.Left:
		dir = Vector2.LEFT
	raycast.target_position = dir * tileSize
	raycast.force_raycast_update()
	var ob = raycast.get_collider()
	var tileMap := ob as TileMap
	if tileMap:
		if direction == Direction.Right:
			direction = Direction.Left
			sprite.flip_h = false
		else:
			direction = Direction.Right
			sprite.flip_h = true
		return
	position += dir * tileSize


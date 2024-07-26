extends Area2D

class_name Aim

@export var sprite:Sprite2D
@export var raycast: RayCast2D
const tileSize = 16
var currentShadow: Shadow

func move(direction: Vector2):
	raycast.target_position = direction * tileSize
	raycast.force_raycast_update()
	var ob = raycast.get_collider()
	var tileMap := ob as TileMap
	if tileMap:
		return
	position += direction * tileSize

func _on_body_entered(body):
	var shadow := body as Shadow
	
	if not shadow:
		return
	
	currentShadow = shadow

func canAim():
	if not currentShadow:
		return false
	if currentShadow.connectedToPlayer:
		return false
	return true

func _process(_delta):
	if canAim():
		modulate = Color.BLUE
	else:
		modulate = Color.DARK_RED		

func _on_body_exited(body):
	var shadow := body as Shadow
	
	if not shadow:
		return

	if shadow == currentShadow:
		currentShadow = null

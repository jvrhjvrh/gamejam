extends StaticBody2D
class_name Shadow

@onready var raycast: RayCast2D = $RayCast2D
const tileSize: int = 16
var isDestroying: bool = false
var isChecked: bool = false
var connectedToPlayer: bool = false
var completedCheck: bool = false
var player: Player
const inputs: Array[Vector2] = [ Vector2.RIGHT, Vector2.LEFT, Vector2.UP, Vector2.DOWN ]

func destroy():
	if isDestroying:
		return
	isDestroying = true
	for input in inputs:
		raycast.target_position = input * tileSize
		raycast.force_raycast_update()
		var ob = raycast.get_collider()
		var shadow := ob as Shadow
		
		if shadow:
			shadow.destroy()
	if player:
		player.destroy()
	queue_free()
	
func clearIsChecked():
	isChecked = false
	
func _process(_delta):
	if not isChecked:
		isConnectedToPlayer(false)
	if not connectedToPlayer:
		isConnectedToPlayer(true)
	
func isConnectedToPlayer(override: bool) -> bool:
	if isChecked and not override:
		return connectedToPlayer
	isChecked = true		
	if player:
		connectedToPlayer = true
		return true
	for input in inputs:
		raycast.target_position = input * tileSize
		raycast.force_raycast_update()
		var ob = raycast.get_collider()
		var shadow := ob as Shadow
		
		if shadow:
			if shadow.isConnectedToPlayer(false):
				connectedToPlayer = true
				return true
	return false
	

func _on_area_2d_area_entered(area):
	if area.is_in_group("Player"):
		player = area

func _on_area_2d_area_exited(area):
	if area.is_in_group("Player"):
		queue_free()

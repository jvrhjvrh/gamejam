extends Area2D
class_name Player

const AIM = preload("res://Scenes/Aim/aim.tscn")
const SHADOW = preload("res://Scenes/Shadow/shadow.tscn")

@export var raycast: RayCast2D
const tileSize = 16
const moveActions = ["right", "left", "up", "down"]
const potionActions = ["potionU", "potionD", "potionL", "potionR", "aim", "cancel"]


var aimMode: bool = false
var aim: Aim

func getDirection(dir: String) -> Vector2:
	if dir == "right" or dir == "potionR":
		return Vector2.RIGHT
	if dir == "left" or dir == "potionL":
		return Vector2.LEFT
	if dir == "up" or dir == "potionU":
		return Vector2.UP
	return Vector2.DOWN

func _unhandled_input(event: InputEvent):
	for moveAction in moveActions:
		if event.is_action_pressed(moveAction):
			move(moveAction)
	for potionAction in potionActions:
		if event.is_action_pressed(potionAction):
			potionAct(potionAction)
	if event.is_action_pressed('reset'):
		get_tree().reload_current_scene()
	if event.is_action_pressed('passTurn'):
		Turns.endTurn()

func throwPotion():
	if !aim.currentShadow or aim.currentShadow.connectedToPlayer:
		return
	
	var currentShadow: Shadow = aim.currentShadow
	var usedPotion: Array[String] = []
	for p in Potion.potion:
		var direction = getDirection(p)
		currentShadow.raycast.target_position = direction * tileSize
		currentShadow.raycast.force_raycast_update()
		var ob = currentShadow.raycast.get_collider()
		var tileMap := ob as TileMap
		if tileMap:
			continue
		var shadow := ob as Shadow
		if shadow:
			continue
		var newShadow = SHADOW.instantiate()
		newShadow.position = currentShadow.position + direction * tileSize
		get_tree().get_first_node_in_group('main').add_child(newShadow)
		currentShadow = newShadow
		usedPotion.append(p)
	
	for p in usedPotion:
		Potion.potion.erase(p)
	
	Potion.clearPotion()
	aimMode = false
	aim.queue_free()
	if not usedPotion.is_empty():
		Turns.endTurn()
	
	
func potionAct(action: String) -> void:
	match action:
		"potionU", "potionD", "potionL", "potionR":
			Potion.addToPotion(action)
		"aim":
			if not aimMode:
				aimMode = true
				aim = AIM.instantiate()
				aim.position = position
				get_tree().get_first_node_in_group('main').add_child(aim)
			else:
				throwPotion()
		"cancel":
			if not aimMode:
				Potion.clearPotion()
				return
			aimMode = false
			aim.queue_free()
	
func move(dir: String) -> void:
	if !Turns.isPlayerTurn:
		return

	var d: Vector2 = getDirection(dir)
	if aimMode:
		aim.move(d)
		return
	
	raycast.target_position = d * tileSize
	raycast.force_raycast_update()
	
	var ob = raycast.get_collider()
	var staticBody := ob as StaticBody2D
	if not staticBody:
		return

	if staticBody.is_in_group("Shadow"):
		position += d * tileSize
		Turns.endTurn()

func destroy():
	visible = false


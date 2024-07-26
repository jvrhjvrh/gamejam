extends Node
class_name TurnController

var isPlayerTurn: bool = true
var isPlayerInStairs: bool = false
var turns: int = 0

func getIsPlayerInStairs():
	return isPlayerInStairs
func endTurn():
	isPlayerTurn = false
	turns += 1
	await get_tree().create_timer(0.1).timeout
	
	if getIsPlayerInStairs():
		isPlayerTurn = true
		isPlayerInStairs = false
		turns = 0
		return
	
	var enemies = get_tree().get_nodes_in_group("Enemies")
	for enemy in enemies:
		if(enemy.has_method("move")):
			enemy.move()
			await get_tree().create_timer(0.2).timeout
	get_tree().call_group('Shadow', 'clearIsChecked')
	isPlayerTurn = true

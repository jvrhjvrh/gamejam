extends Node
class_name PotionController
var potion: Array[String] = []
const POTION_MAX_SIZE = 4

func addToPotion(value: String):
	if potion.size() >= POTION_MAX_SIZE:
		return
	potion.append(value)

func clearPotion():
	potion = []

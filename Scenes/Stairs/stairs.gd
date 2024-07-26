extends Area2D

@export var load: Resource
func _on_area_entered(area):
	if area.is_in_group("Player"):
		Turns.isPlayerInStairs = true
		Potion.clearPotion()
		await get_tree().change_scene_to_file(load.resource_path)

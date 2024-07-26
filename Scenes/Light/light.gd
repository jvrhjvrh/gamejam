extends Area2D

func _on_body_entered(body):
	var shadow := body as Shadow
	if not shadow:
		return
	shadow.destroy()

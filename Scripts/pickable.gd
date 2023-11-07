extends Area2D
class_name  Pickable
@export var item_name = ""


func _on_body_entered(body):
	if body is Player:
		print("Picked up")
		body.item_equipped = item_name
		print(body.item_equipped)
		queue_free()

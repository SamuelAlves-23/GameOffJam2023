extends Area2D
class_name  Pickable
@export var item_name = ""


func _on_body_entered(body):
	print("Picked up")
	body.item_equipped = item_name
	queue_free()

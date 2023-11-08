extends Node

@export var health = 3
@onready var parent = get_parent()


func take_damage(damage):
	health -= damage
	print(health)
	print(damage)
	if health <= 0 && parent is Enemy:
		die()

func die():
	get_parent().queue_free()

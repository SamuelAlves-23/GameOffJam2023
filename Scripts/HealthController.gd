extends Node

@export var health = 3


func take_damage(damage):
	health -= damage
	print(health)
	print(damage)
	if health <= 0:
		die()

func die():
	get_parent().queue_free()

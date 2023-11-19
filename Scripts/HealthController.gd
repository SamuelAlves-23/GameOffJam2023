extends Node

@export var health = 3
@onready var parent = get_parent()
@onready var arena = get_tree().get_first_node_in_group("Arena")

func take_damage(damage):
	health -= damage
	if health <= 0 && parent is Enemy:
		arena.add_score()
		die()
		if arena.score % 10 == 0:
			arena.spawn_pickable(parent)

func die():
	get_parent().queue_free()

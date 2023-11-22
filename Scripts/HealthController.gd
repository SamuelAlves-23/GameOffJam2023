extends Node

@export var health = 3
@onready var parent = get_parent()
@onready var arena = get_tree().get_first_node_in_group("Arena")
@onready var death_effect = preload("res://Scenes/death_effect.tscn")

func take_damage(damage):
	
	if !parent.invulnerable:
		health -= damage
		
	
	if parent is Player && !parent.invulnerable:
		parent.invulnerable = true
		print(parent.invulnerable)
		for i in 10:
			parent.sprite.visible = false
			await await get_tree().create_timer(0.1).timeout
			parent.sprite.visible = true
			await await get_tree().create_timer(0.1).timeout
		
		parent.invulnerable = false
		print(parent.invulnerable)
	if health <= 0 && parent is Enemy:
		arena.add_score()
		die()
		if arena.score % 10 == 0:
			arena.spawn_pickable(parent.global_position)

func heal():
	if health < 3:
		health += 1

func die():
	get_parent().queue_free()
	var death_effect_instance = death_effect.instantiate()
	parent.get_parent().add_child(death_effect_instance)
	death_effect_instance.global_position = parent.global_position
